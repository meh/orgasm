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
        destination, sources = params

        known = definition.reverse.drop_while {|x|
          !x.is_a?(Integer)
        }.reverse.map {|x|
          [x].flatten.pack('C*')
        }.join

        on known do |whole, which|
          opcodes = definition.clone
          opcodes.slice! 0 ... known.length

          seek which.length do
            modr = if opcodes.first.is_a?(String) || opcodes.first == :r
              X86::ModR.new(read(1).to_byte)
            end

            return if modr && opcodes.first.is_a?(String) && modr.opcode != opcodes.shift.to_i

            displacement = modr && read(
              if    modr.mod == '00'.to_i(2) && modr.rm == '101'.to_i(2) then 32.bit
              elsif modr.mod == '01'.to_i(2)                             then 8.bit
              elsif modr.mod == '10'.to_i(2)                             then 32.bit
              end
            ).to_bytes rescue nil

            immediate = if X87::Data.valid?(opcodes.first)
              X87::Data.new(self, opcodes.first).tap {|o|
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
      on description.map { |b| [b].flatten.compact.pack('C*') }.join do |whole, which|
        seek which.length

        X87::Instruction.new(name)
      end
    end
  }
}
