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
      description.each {|params, opcodes|
        opcodes = opcodes.clone
        known   = opcodes.reverse.drop_while {|x| !x.is_a?(Integer)}.reverse.map {|x| x.chr}.join
        opcodes.slice! known.length

        on known do |whole, which|
          seek which.length do
            if opcodes.first.is_a?(String)
              check = opcodes.shift.to_i

              read 1 do |data|
                skip unless ((data.to_byte & '00111000'.to_i(2)) >> 3) == check
              end

              opcodes.shift
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
