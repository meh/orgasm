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

# undocumented opcode holes
holes = [0x66, 0x67, 0xC1]

decoder do
	while holes.member?(current = read(1).to_byte); end

	possible = instructions.lookup.select {|p|
		p.description[0] === current
	}

	index = 1

	until possible.length == 1 or possible.empty?
		current = read(1).to_byte

		possible.select! {|p|
			p.description[index] === current
		}
		
		index += 1
	end

	return if possible.empty?

	instruction                  = possible[0]
	name                         = instruction.name
	description                  = instruction.description
	opcodes                      = description.opcodes
	destination, source, source2 = instruction.parameters

	if bits = X86::Instructions.register_code?(opcodes.last)
		X86::Instruction.new(name) {|i|
			register = X86::Register.new(X86::Instructions.register(current - description[0].to_i, bits))

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
	else
	end
end

return

instructions.each {|name, description|
	description.each {|description|
		if description.is_a?(Hash)
			description.each {|params, definition|
				destination, source, source2 = params

				known = definition.reverse.drop_while {|x|
					!x.is_a?(Integer)
				}.reverse

				if bits = X86::Instructions.register_code?(definition.last)
					0.upto 7 do |n|
						on known.clone, code: n do |whole, which, data|
							seek which.length

							reg = X86::Register.new(X86::Instructions.register(data[:code], bits))

							X86::Instruction.new(name) {|i|
								if !source
									i.destination = reg
								else
									i.destination, i.source = if destination =~ :r
										[reg, X86::Register.new(source)]
									else
										[X86::Register.new(destination), reg]
									end
								end
							}
						end

						known[-1] += 1
					end

					next
				end

				on known do |whole, which|
					opcodes = definition.clone
					opcodes.slice! 0 ... known.length

					seek which.length do
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
					end
				end
			}
		else
			description = description.clone
			ahead       = description.last.is_a?(Array) ? description.pop : []

			on description + ahead, ahead: ahead do |whole, which, data|
				seek which.length - data[:ahead].length

				X86::Instruction.new(name)
			end
		end
	}
}
