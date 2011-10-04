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

# undocumented opcode holes, excluding the size prefixes
on 0xC1 do
	seek +1 and done
end

always do
	prefixes ||= X86::Prefixes.new

	while prefix = X86::Prefixes.valid?(lookahead(1).to_byte)
		prefixes << prefix

		seek +1
	end

	after do
		prefixes.clear
	end

	instructions.each {|name, description|
		description.each {|description|
			if description.is_a?(Hash)
				description.each {|params, definition|
					destination, source, source2 = params

					next if (options[:mode] == :real && destination.bits == 16 && prefixes.operand?) ||
					        (options[:mode] != :real && destination.bits == 32 && prefixes.operand?)

					known = definition.reverse.drop_while {|x|
						!x.is_a?(Integer)
					}.reverse

					if bits = X86::Instructions.register_code?(definition.last)
						0.upto 7 do |n|
							on known do |whole, which|
								seek which.length

								reg = X86::Register.new(X86::Instructions.register_code(n, bits))

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
					end

					on known do |whole, which|
						opcodes = definition.clone
						opcodes.slice! 0 ... known.length

						seek which.length do
							modr = if opcodes.first.is_a?(String) || opcodes.first == :r
								X86::ModR.new(read(1).to_byte)
							end

							return if modr && opcodes.first.is_a?(String) && modr.opcode != opcodes.shift.to_i

							sib = if modr && modr.mod != '11'.bin && modr.rm == '100'.bin && !(options[:mode] != :real && prefixes.size?)
								X86::SIB.new(read(1).to_byte)
							end

							displacement = if modr then read(
								if prefixes.address? || (options[:mode] == :real && !prefixes.address?)
									if    modr.mod == '00'.bin && modr.rm == '110'.bin then 16.bit
									elsif modr.mod == '01'.bin                         then 8.bit
									elsif modr.mod == '10'.bin                         then 16.bit
									end
								else
									if    modr.mod == '00'.bin && modr.rm == '101'.bin then 32.bit
									elsif modr.mod == '01'.bin                         then 8.bit
									elsif modr.mod == '10'.bin                         then 32.bit
									end
								end
							).to_bytes end

							immediates = 0.upto(1).map {
								X86::Data.new(self, opcodes.pop) if X86::Data.valid?(opcodes.last)
							}.compact.reverse

							X86::Instruction.new(name) {|i|
								next if params.ignore?

								{ destination: destination, source: source, source2: source2 }.each {|type, obj|
									next unless obj

									i.send "#{type}=", if X86::Instructions.register?(obj)
										X86::Register.new(obj)
									elsif obj =~ :imm || obj =~ :rel
										immediate = immediates.shift

										if obj =~ :imm
											X86::Immediate.new(immediate.to_i, immediate.size)
										else
											X86::Address.new(immediate.to_i, immediate.size, relative: true)
										end
									elsif obj =~ :m && modr.mod != '11'.bin
										X86::Address.new(displacement, obj.bits)
									elsif obj =~ :r && opcodes.first == :r
										X86::Register.new(X86::Instructions.register(obj =~ :m ? modr.rm : modr.reg, obj.bits))
									elsif obj =~ :r
										X86::Register.new(X86::Instructions.register(modr.rm, obj.bits))
									else
										raise ArgumentError, "dont know what to do with #{obj} as #{type}"
									end
								}

								prefixes.clear
							}
						end
					end
				}
			else
				on description do |whole, which|
					seek which.length

					X86::Instruction.new(name)
				end
			end
		}
	}
end
