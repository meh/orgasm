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
  prefixes = []
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

          on known do |whole, which|
            seek which.length do
              modr = if opcodes.first.is_a?(String) || opcodes.first == :r
                I386::ModR.new(read(1).to_byte)
              end

              skip if modr && opcodes.first.is_a?(String) && modr.opcode != opcodes.shift.to_i

              data = if I386::Data.is?(opcodes.first)
                I386::Data.new(self, opcodes.first).tap {|o|
                  skip if o.size == 2 && !prefixes.member?(:operand)
                }
              end

              I386::Instruction.new(name) {|i|
                i.destination = if instructions.register?(destination)
                  I386::Register.new(destination)
                elsif destination.to_s.match(/^imm/)
                  I386::Immediate.new(data.to_i, data.size)
                else
                  raise ArgumentError, "dont know what to do with #{destination} as destination"
                end

                next unless source

                i.source = if source.to_s.match(/^imm/)
                  I386::Immediate.new(data.to_i, data.size)
                else
                  raise ArgumentError, "dont know what to do with #{source} as source"
                end

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
