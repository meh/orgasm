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

X86::Instructions[X86::DSL.new(16) {
  # ASCII Adjust After Addition
  AAA [0x37]

  # ASCII Adjust AX Before Division
  AAD [0xD5, 0x0A],
      [imm8] => [0xD5, ib]

  # ASCII Adjust AX After Multiply
  AAM [0xD4, 0x0A],
      [imm8] => [0xD4, ib]

  # ASCII Adjust AL After Substraction
  AAS [0x3F]

  # Add
  ADD [al,      imm8]    => [0x04, ib],
      [ax,      imm16]   => [0x05, iw],
      [r8|m8,   imm8]    => [0x80, ?0, ib],
      [r16|m16, imm16]   => [0x81, ?0, iw],
      [r16|m16, imm8]    => [0x83, ?0, ib],
      [r8|m8,   r8]      => [0x00, r],
      [r16|m16, r16]     => [0x01, r],
      [r8,      r8|m8]   => [0x02, r],
      [r16,     r16|m16] => [0x03, r]

}]
