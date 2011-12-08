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

begin
	require 'ffi/inliner'; extend FFI::Inliner

	# TODO: add register check for specific register opcodes
	inline do |c|
		c.compiler.options = '-O3 -march=native -mtune=native'

		c.include 'string.h'

		c.raw %{
			enum instruction_type_t { Normal, Splat };

			typedef struct instruction_t {
				char type;

				short opcodes[2];
				short modr;
			} instruction_t;

			static instruction_t instructions[] = { #{
				instructions.lookup.table.map {|t|
					"{ #{t.type.capitalize}, { #{t.opcodes.join ', '} }, #{t.modr} }"
				}.join ", "
			} };

			static int instructions_length = sizeof(instructions) / sizeof(instructions[0]);
		}

		c.function %q{
			#define REG(x)     ((x & 0x38) >> 3)
			#define PRESENT(x) (x != -1)

			int find_lookup_index (const unsigned char* buffer, size_t length) {
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
	warn 'could not inline C, performance will be even worse'
	warn e.message

	def reg (x)
		(x & 0x38) >> 3
	end

	def present? (x)
		x != -1
	end

	def find_lookup_index (buffer, length)
		first, second, third = buffer.bytes.map &:ord

		instructions.lookup.table.each_with_index {|current, index|
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
	@prefixes     ||= X86::Prefixes.new(16, options)

	@prefixes.clear
	while prefix = @prefixes.valid?((data = @io.read(1) or return).to_byte)
		@prefixes << prefix
	end

	if tmp = @io.read(2)
		data << tmp
	end

	current = disassembler.find_lookup_index(data, data.length)

	return if current == -1

	instruction         = @instructions.lookup[current]
	name                = instruction.name
	definition          = instruction.definition
	opcodes             = definition.opcodes
	parameters          = instruction.parameters
	destination, source = parameters
	modr                = data[definition.known.length].to_byte if definition.modr?

	# seek back for the unused data
	seek -(data.length - definition.known.length - (modr ? 1 : 0))

	if definition.member?(:i)
		X87::Instruction.new(name) {|i|
			stack = X87::Stack.new(data[0].to_byte - definition[0].min)

			if !source
				i.destination = stack
			else
				i.destination, i.source = if destination =~ :r
					[stack, X87::Stack.new(source)]
				else
					[X87::Stack.new(destination), stack]
				end
			end
		}
	elsif !destination || parameters.hint?
		X87::Instruction.new(name)
	else
		modr = X86::ModR.new(modr) if modr

		displacement = read(modr.displacement_size(16)).to_bytes(signed: true) if modr

		X87::Instruction.new(name) {|i|
			i.destination = X87::Address.new(modr.effective_address(16, displacement), destination.bits, destination.type)
		}
	end or return
end
