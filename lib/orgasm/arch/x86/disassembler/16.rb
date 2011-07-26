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
on 0x66, 0x67, 0xC1 do
  seek +1
end

instructions.to_hash.each {|name, description|
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

              reg = X86::Register.new(X86::Instructions.register_code(data[:code], bits))

              X86::Instruction.new(name) {|i|
                if !source
                  i.destination = reg
                else
                  i.destination, i.source = if destination.is?(:r)
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
            modr = if opcodes.first.is_a?(String) || opcodes.first == :r
              X86::ModR.new(read(1).to_byte)
            end

            return if modr && opcodes.first.is_a?(String) && modr.opcode != opcodes.shift.to_i

            displacement = modr && read(
              if    modr.mod == '00'.to_i(2) && modr.rm == '110'.to_i(2) then 16.bit
              elsif modr.mod == '01'.to_i(2)                             then 8.bit
              elsif modr.mod == '10'.to_i(2)                             then 16.bit
              end
            ).to_bytes rescue nil

            immediates = 0.upto(1).map {
              X86::Data.new(self, opcodes.pop) if X86::Data.valid?(opcodes.last)
            }.compact.reverse

            X86::Instruction.new(name) {|i|
              next if params.ignore?

              { destination: destination, source: source, source2: source2 }.each {|type, obj|
                next unless obj

                i.send "#{type}=", if X86::Instructions.register?(obj)
                  X86::Register.new(obj)
                elsif obj.is?(:imm)
                  immediate = immediates.shift

                  X86::Immediate.new(immediate.to_i, immediate.size)
                elsif obj.is?(:m) && displacement
                  X86::Address.new(displacement, obj.bits)
                elsif obj.is?(:m) && modr.mod != '11'.to_i(2)
                  X86::Address.new(modr.rm, obj.)
                elsif obj.is?(:r) && opcodes.first == :r
                  X86::Register.new(X86::Instructions.register({ destination: modr.reg, source: modr.rm }[type], obj.to_s[/\d+$/].to_i))
                elsif obj.is?(:r)
                  X86::Register.new(X86::Instructions.register(modr.rm, obj.to_s[/\d+$/].to_i))
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

        X86::Instruction.new(name)
      end
    end
  }
}
