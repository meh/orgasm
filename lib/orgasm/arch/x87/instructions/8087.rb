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

X87::Instructions[X87::DSL.new {
  # Compute 2^x-1
  F2XM1 [0xD9, 0xF0]

  # Absolute Value
  FABS [0xD9, 0xE1]

  # Add
  FADD [m32real]    => [0xD8, ?0],
       [m64real]    => [0xDC, ?0],
       # The Intel reference states this, but it doesn't work, nasm generates what's below
       # [:ST0, :STi] => [0xD8, 0xC0, i],
       # [:STi, :ST0] => [0xDC, 0xC0, i],
       [st0, sti] => [0xC0, i, 0xD8],
       [sti, st0] => [0xC0, i, 0xDC]

  FADDP [0xDE, 0xC1],
        [sti, st0] => [0xDE, 0xC0, i]

  FIADD [m32int] => [0xDA, ?0],
        [m64int] => [0xDE, ?0]
}]
