#--
# Copyleft meh. [http://meh.paranoid.pk | meh@paranoici.org]
#
# This file is part of orgasm.
#
# orgasm is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# orgasm is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with orgasm. If not, see <http://www.gnu.org/licenses/>.
#++

options[:mode] = :protected

begin
	require 'ffi/inliner'; extend FFI::Inliner

	# TODO: add register check for specific register opcodes
	inline do |c|
		c.compiler.options = '-O3 -march=native -mtune=native'

		c.include 'string.h'

		c.raw %{
			enum instruction_type_t { Normal, Splat };

			typedef struct instruction_t {
				char bits;
				char type;

				short opcodes[2];
				short modr;
			} instruction_t;

			static instruction_t instructions[] = { #{
				instructions.lookup.table.map {|t|
					"{ #{t.bits}, #{t.type.capitalize}, { #{t.opcodes.join ', '} }, #{t.modr} }"
				}.join ", "
			} };

			static int instructions_length = sizeof(instructions) / sizeof(instructions[0]);
		}

		c.function %q{
			#define REG(x)     ((x & 0x38) >> 3)
			#define PRESENT(x) (x != -1)

			int find_lookup_index (const unsigned char* buffer, size_t length, char bits) {
				instruction_t* current = NULL;
				int            i       = 0;

				for (i = 0; i < instructions_length; i++) {
					current = &instructions[i];

					if (current->bits != 8 && PRESENT(bits) && current->bits != bits) {
						continue;
					}

					if (current->type == Splat) {
						if (buffer[0] >= current->opcodes[0] && buffer[0] < (current->opcodes[0] + 8)) {
							return i;
						}
					}
					else {
						if (buffer[0] == current->opcodes[0]) {
							if (PRESENT(current->opcodes[1])) {
								if (length >= 2 && buffer[1] == current->opcodes[1]) {
									if (PRESENT(current->modr)) {
										if (length >= 3 && REG(buffer[2])) {
											return i;
										}
									}
									else {
										return i;
									}
								}
							}
							else {
								if (PRESENT(current->modr)) {
									if (length >= 2 && REG(buffer[1]) == current->modr) {
										return i;
									}
								}
								else {
									return i;
								}
							}
						}
					}
				}

				return -1;
			}
		}
	end
rescue Exception => e
	warn 'could not inline C, performance will be poor'
	warn e.message

	def reg (x)
		(x & 0x38) >> 3
	end

	def present? (x)
		x != -1
	end

	def find_lookup_index (buffer, length, bits)
		first, second, third = buffer.bytes.map &:ord

		instructions.lookup.table.each_with_index {|current, index|
			next if current.bits != 8 && present?(bits) && current.bits != bits
				
			if current.type == :splat
				return index if buffer[0].ord >= current.opcodes[0] && first < (current.opcodes[0] + 8)
			else
				if first == current.opcodes[0]
					if present?(current.opcodes[1])
						if length >= 2 && second == current.opcodes[1]
							if present?(current.modr)
								return index if length >= 3 && reg(third) == current.modr
							else
								return index
							end
						end
					else
						if present?(current.modr)
							return index if length >= 2 && reg(second) == current.modr
						else
							return index
						end
					end
				end
			end
		}

		return -1
	end
end

decoder do
	@instructions ||= instructions
	@prefixes     ||= X86::Prefixes.new(32, options)

	@prefixes.clear
	while prefix = @prefixes.valid?((data = @io.read(1) or return).to_byte)
		@prefixes << prefix
	end

	if tmp = @io.read(2)
		data << tmp
	end

	bits = if @prefixes.operand?
		options[:mode] == :protected ? 16 : 32
	else
		options[:mode] == :protected ? 32 : 16
	end

	current = disassembler.find_lookup_index(data, data.length, bits || -1)

	return if current == -1

	instruction                  = @instructions.lookup[current]
	name                         = instruction.name
	definition                   = instruction.definition
	opcodes                      = definition.opcodes
	parameters                   = instruction.parameters
	destination, source, source2 = parameters
	modr                         = data[definition.known.length].to_byte if definition.modr?

	# seek back for the unused data
	seek -(data.length - definition.known.length - (modr ? 1 : 0))

	instruction = if bits = X86::Instructions.register_code?(opcodes[-1])
		X86::Instruction.new(name) {|i|
			register = X86::Register.new(X86::Instructions.register(data[0].to_byte - definition[0].min, bits))

			if !source
				i.destination = register
			else
				i.destination, i.source = if destination =~ :r
					[register, X86::Register.new(source)]
				else
					[X86::Register.new(destination), register]
				end
			end
		}
	elsif !destination || parameters.hint?
		X86::Instruction.new(name)
	else
		modr = X86::ModR.new(modr) if modr
		sib  = X86::SIB.new(read(1).to_byte) if modr && modr.sib? && !(options[:mode] == :protected && @prefixes.size?)

		displacement = read(modr.displacement_size(@prefixes.size)).to_bytes(signed: true) if modr

		immediates = opcodes.reverse.take_while {|o|
			X86::Data.valid?(o)
		}.map {|o|
			X86::Data.new(self, o)
		}.compact.reverse

		X86::Instruction.new(name) {|i|
			{ destination: destination, source: source, source2: source2 }.each {|type, obj|
				next unless obj

				i.send "#{type}=", if X86::Instructions.register?(obj)
					X86::Register.new(obj)
				elsif obj =~ :imm || obj =~ :rel || obj =~ :moffs
					immediate = immediates.shift

					if obj =~ :imm
						X86::Immediate.new(immediate.to_i, immediate.size)
					elsif obj =~ :rel
						X86::Address.new(immediate.to_i, immediate.size, relative: true)
					elsif obj =~ :moffs
						X86::Address.new(immediate.to_i, immediate.size, offset: true)
					end
				elsif modr && modr.memory? && obj =~ :m
					X86::Address.new(modr.effective_address(@prefixes.size, displacement), obj.bits)
				elsif modr && obj =~ :r && opcodes.first == :r
					X86::Register.new(X86::Instructions.register(obj =~ :m ? modr.rm : modr.reg, obj.bits))
				elsif modr && obj =~ :r
					X86::Register.new(X86::Instructions.register(modr.rm, obj.bits))
				else
					raise ArgumentError, "dont know what to do with #{obj} as #{type}"
				end
			}
		}
	end or return

	instruction.repeat! if @prefixes.repeat?
	instruction.lock!   if @prefixes.lock?

	instruction
end
