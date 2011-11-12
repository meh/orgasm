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

return

# undocumented opcode holes
on 0x66, 0x67, 0xC1 do
	seek +1 and done
end

instructions.each {|name, description|
	description.each {|description|
		if description.is_a?(Hash)
			description.each {|params, definition|
				destination, source = params

				known = definition.reverse.drop_while {|x|
					!x.is_a?(Integer)
				}.reverse

				if definition.member?(:i)
					opcodes = definition.clone
					index   = definition.index(opcodes.delete(:i)) - 1

					0.upto 7 do |n|
						on opcodes.clone, code: n do |whole, which, data|
							seek which.length

							stack = X87::Stack.new(data[:code])

							X87::Instruction.new(name) {|i|
								if source.nil?
									i.destination = stack
								else
									i.destination, i.source = if destination.is?(:r)
										[stack, X87::Stack.new(sources.first.downcase)]
									else
										[X87::Stack.new(destination.downcase), stack]
									end
								end
							}
						end

						opcodes[index] += 1
					end

					next
				end

				on known do |whole, which|
					opcodes = definition.clone
					opcodes.slice! 0 ... which.length

					seek which.length do
						modr = X86::ModR.new(read(1).to_byte) if opcodes.first.is_a?(String) || opcodes.first == :r

						# return when the /n is wrong
						return if modr && opcodes.first.is_a?(String) && modr.opcode != opcodes.shift.to_i

						# TODO: add register check for specific register opcodes

						displacement = read(modr.displacement_size(16)).to_bytes(signed: true) if modr

						X87::Instruction.new(name) {|i|
							i.destination = X87::Address.new(modr.effective_address(16, displacement), destination.bits, destination.type)
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
