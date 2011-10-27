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
	prefixes ||= X86::Prefixes.new(options)

	while prefix = X86::Prefixes.valid?(lookahead(1).to_byte)
		prefixes << prefix

		seek +1
	end

	after do
		prefixes.clear
	end

	instructions.to_hash.each {|name, description|
		description.each {|description|
			if description.is_a?(Hash)
				description.each {|params, definition|
					destination, source, source2 = params

					known = definition.reverse.drop_while {|x|
						!x.is_a?(Integer)
					}.reverse

					on known do |whole, which|
						opcodes = definition.clone
						opcodes.slice! 0 ... which.length

						seek which.length do
							modr = X86::ModR.new(read(1).to_byte) if opcodes.first.is_a?(String) || opcodes.first == :r
							sib  = X86::SIB.new(read(1).to_byte)  if modr && modr.sib? && !(options[:mode] != :real && prefixes.size?)

							# return when the /n is wrong
							return if modr && opcodes.first.is_a?(String) && modr.opcode != opcodes.shift.to_i

							# TODO: add register check for specific register opcodes
							# TODO: add SIB memory thing

							displacement = read(modr.displacement_size(prefixes.size)).to_bytes(signed: true) if modr

							immediates = 0.upto(1).map {
								X86::Data.new(self, opcodes.pop) if X86::Data.valid?(opcodes.last)
							}.compact.reverse

							SIMD::X86::Instruction.new(name) {|i|
								next if params.ignore?

								{ destination: destination, source: source, source2: source2 }.each {|type, obj|
									next unless obj

									i.send "#{type}=", if SIMD::X86::Instructions.register?(obj)
										SIMD::X86::Register.new(obj)
									elsif obj =~ :imm
										immediate = immediates.shift

										SIMD::X86::Immediate.new(immediate.to_i, immediate.size)
									elsif obj =~ :r && opcodes.first == :r
										SIMD::X86::Register.new(SIMD::X86::Instructions.register(obj =~ :m ? modr.rm : modr.reg, obj.type))
									elsif obj =~ :r
										SIMD::X86::Register.new(SIMD::X86::Instructions.register(modr.rm, obj.type))
									else
										raise ArgumentError, "dont know what to do with #{obj} as #{type}"
									end
								}
							}
						end
					end
				}
			else
				on description do |whole, which|
					seek which.length

					SIMD::X86::Instruction.new(name)
				end
			end
		}
	}
end
