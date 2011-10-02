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

instructions.to_hash.each {|name, description|
	description.each {|description|
		if description.is_a?(Hash)
			description.each {|params, definition|
				destination, *sources = params

				if definition.member?(:i)
					opcodes = definition.clone
					index   = definition.index(opcodes.delete(:i)) - 1

					0.upto 7 do |n|
						on opcodes.clone, code: n do |whole, which, data|
							seek which.length

							stack = X87::Stack.new(data[:code])

							X86::Instruction.new(name) {|i|
								if sources.empty?
									i.destination = stack
								else
									i.parameters.insert -1, *(if destination.is?(:r)
										[stack, X87::Stack.new(sources.first.downcase)]
									else
										[X87::Stack.new(destination.downcase), stack]
									end)
								end
							}
						end

						opcodes[index] += 1
					end

					next
				end

				on definition.reverse.drop_while {|x| !x.is_a?(Integer) }.reverse do |whole, which|
					opcodes = definition.clone
					opcodes.slice! 0 ... which.length

					seek which.length do
						modr = if opcodes.first.is_a?(String) || opcodes.first == :r
							X86::ModR.new(read(1).to_byte)
						end

						return if modr && opcodes.first.is_a?(String) && modr.opcode != opcodes.shift.to_i

						return if modr && destination.is?(:m) && modr.mod == '11'.bin

						displacement = modr && read(
							if    modr.mod == '00'.bin && modr.rm == '101'.bin then 32.bit
							elsif modr.mod == '01'.bin                         then 8.bit
							elsif modr.mod == '10'.bin                         then 32.bit
							end
						).to_bytes rescue nil

						immediate = if X86::Data.valid?(opcodes.first)
							X86::Data.new(self, opcodes.first).tap {|o|
								return if o.size == 2 && !prefixes.small?
							}
						end

						X87::Instruction.new(name) {|i|
							next if params.ignore?
						}
					end
				end
			}
		else
			on description do |whole, which|
				seek which.length

				X87::Instruction.new(name)
			end
		end
	}
}
