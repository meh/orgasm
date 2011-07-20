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

module Orgasm

Disassembler.for('i386') {
  ESP = 0x04

  on ?\x01, ?\x09, ?\x11, ?\x19, ?\x21, ?\x25, ?\x29, ?\x31, ?\x39, ?\x85, ?\x86, ?\x87, ?\x89, ?\xA1, ?\xA3 do
    increment = 1

    seek 1 do
      read 1 do |data|
        increment += 1 if data.to_byte & 0x07 == ESP
        increment += 1 if (data.to_byte & 0xC0) >> 6 == 0x01

        if (data.to_byte & 0xC0) >> 6 == 0x10
          Unknown.new(1)
        end
      end
    end

    on ?\x01 do
      Instruction.new(:add) {
        seek +1

        seek +1
      }
    end
  end
}

end
