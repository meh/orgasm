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

prefixes = []

skip do
  prefixes.clear
end

instructions.to_hash.each {|name, description|
  description.each {|description|
    if description.is_a?(Hash)
      description.each {|params, opcodes|
        destination = params.first
        source      = params.last
        opcodes     = opcodes.clone
        known       = opcodes.reverse.drop_while {|x| !x.is_a?(Integer)}.reverse.map {|x| x.chr}.join
        opcodes.slice! 0 ... known.length

        always do
          while prefix = I386::Instruction.prefix?(lookahead(1).to_byte)
            prefixes << prefix unless prefixes.member?(prefix)
            seek +1
          end

          small = prefixes.member?(:operand) || prefixes.member?(:address)

          on known do |whole, which|
            seek which.length do
              modr = if opcodes.first.is_a?(String) || opcodes.first == :r
                I386::ModR.new(read(1).to_byte)
              end

              skip if modr && opcodes.first.is_a?(String) && modr.opcode != opcodes.shift.to_i

              sib = if modr && modr.mod != '11'.to_i(2) && modr.rm == '100'.to_i(2) && !small
                I386::SIB.new(read(1).to_byte)
              end

              displacement = modr && read(
                if small
                  if    modr.mod == '00'.to_i(2) && modr.rm == '110'.to_i(2) then 16.bit
                  elsif modr.mod == '01'.to_i(2)                             then 8.bit
                  elsif modr.mod == '10'.to_i(2)                             then 16.bit
                  end
                else
                  if    modr.mod == '00'.to_i(2) && modr.rm == '101'.to_i(2) then 32.bit
                  elsif modr.mod == '01'.to_i(2)                             then 8.bit
                  elsif modr.mod == '10'.to_i(2)                             then 32.bit
                  end
                end
              ).to_bytes rescue nil

              immediate = if I386::Data.valid?(opcodes.first)
                I386::Data.new(self, opcodes.first).tap {|o|
                  skip if o.size == 2 && !small
                }
              end

              skip if !small && (destination.to_s[/\d+$/].to_i == 16 || source.to_s[/\d+$/].to_i == 16)

              I386::Instruction.new(name) {|i|
                { destination: destination, source: source }.each {|type, obj|
                  i.send "#{type}=", if instructions.register?(obj)
                    I386::Register.new(obj)
                  elsif obj.is?(:imm)
                    I386::Immediate.new(immediate.to_i, immediate.size)
                  elsif obj.is?(:m) && displacement
                    I386::Address.new(displacement, (obj.second rescue obj).to_s[/\d+$/].to_i)
                  elsif obj.is?(:r)
                    if opcodes.first == :r
                      I386::Register.new(instructions.register({ destination: modr.reg, source: modr.rm }[type], obj.to_s[/\d+$/].to_i))
                    else
                      I386::Register.new(instructions.register(modr.rm, obj.to_s[/\d+$/].to_i))
                    end
                  else
                    raise ArgumentError, "dont know what to do with #{obj} as #{type}"
                  end
                }

                prefixes.clear
              }
            end
          end
        end
      }
    else
      on description.map {|b| b.chr}.join do |whole, which|
        seek which.length

        I386::Instruction.new(name)
      end
    end
  }
}
