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

require 'ffi/inliner'; extend FFI::Inliner

inline do |c|
	c.compiler.options = '-O3'

	c.include 'string.h'

	c.raw %{
		#define REG(x) ((x & 0x38) >> 3)
		#define PRESENT(x) (x != -1)

		enum instruction_type_t { Normal, Splat };

		typedef struct instruction_t {
			char bit;
			char type;

			short opcodes[2];
			short modr;
		} instruction_t;

		static instruction_t instructions[] = { #{
			instructions.lookup.map {|i|
				bits = if i.parameters && i.parameters.destination
					i.parameters.destination.bits
				else
					0
				end

				type = if i.definition[0].is_a?(Range)
					'Splat'
				else
					'Normal'
				end

				first = if i.definition[0].is_a?(Integer) || i.definition[0].is_a?(Range)
					i.definition[0].is_a?(Range) ? i.definition[0].min : i.definition[0]
				else
					-1
				end

				second = if i.definition[1].is_a?(Integer)
					i.definition[1]
				else
					-1
				end

				modr = if i.definition[2].is_a?(String)
					i.definition[2].to_i
				else
					-1
				end

				"{ #{bits}, #{type}, { #{first}, #{second} }, #{modr} }"
			}.join ", "
		} };

		static int instructions_length = sizeof(instructions) / sizeof(instructions[0]);
	}

	c.function %q{
		int find_lookup_index (const char* buffer, size_t length) {
			instruction_t* current = NULL;
			int            i       = 0;

			for (i = 0; i < instructions_length; i++) {
				current = &instructions[i];

				if (current->type == Splat) {
					if (buffer[0] >= current->opcodes[0] && buffer[0] < (current->opcodes[0] + 8)) {
						return i;
					}
				}
				else {
					if (buffer[0] == current->opcodes[0]) {
						if (PRESENT(current->opcodes[1])) {
							if (buffer[1] == current->opcodes[1]) {
								if (PRESENT(current->modr)) {
									if (REG(buffer[2])) {
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
								if (REG(buffer[1])) {
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

decoder do
	prefixes.clear
	
	while prefix = prefixes.valid?((current = read(1)).to_byte)
		prefixes << prefix and seek +1
	end

	begin
		data    = current << @io.read(3 - current.length)
		current = find_lookup_index(data, data.length)

		return if current == -1
	rescue
		return
	end

	instruction                  = instructions.lookup[current]
	name                         = instruction.name
	definition                   = instruction.definition
	opcodes                      = definition.opcodes
	destination, source, source2 = instruction.parameters

	next

	if bits = X86::Instructions.register_code?(opcodes[-1])
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
	elsif !destination
		X86::Instruction.new(name)
	else
		next

		modr = X86::ModR.new(read(1).to_byte) if opcodes.first.is_a?(String) || opcodes.first == :r

		# return when the /n is wrong
		return if modr && opcodes.first.is_a?(String) && modr.opcode != opcodes.shift.to_i

		# TODO: add register check for specific register opcodes

		displacement = read(modr.displacement_size(16)).to_bytes(signed: true) if modr

		immediates = 0.upto(1).map {
			X86::Data.new(self, opcodes.pop) if X86::Data.valid?(opcodes.last)
		}.compact.reverse

		X86::Instruction.new(name) {|i|
			next if params.hint?

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
				elsif modr && !modr.register? && obj =~ :m
					X86::Address.new(modr.effective_address(16, displacement), obj.bits)
				elsif obj =~ :r && opcodes.first == :r
					X86::Register.new(X86::Instructions.register(obj =~ :m ? modr.rm : modr.reg, obj.bits))
				elsif obj =~ :r
					X86::Register.new(X86::Instructions.register(modr.rm, obj.bits))
				else
					raise ArgumentError, "dont know what to do with #{obj} as #{type}"
				end
			}
		}
	end.tap {|i|
		i.repeat! if prefixes.repeat?
		i.lock!   if prefixes.lock?
	}
end

decoder.instance_eval {
	define_singleton_method :prefixes do
		@prefixes ||= X86::Prefixes.new(16, options)
	end
}
