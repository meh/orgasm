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

X86::Instructions[X86::DSL.new(32) {
  # Add with Carry
  ADC [eax,     imm32]   => [0x15, id],
      [r32|m32, imm32]   => [0x81, ?2, id],
      [r32|m32, imm8]    => [0x83, ?2, ib],
      [r32|m32, r32]     => [0x11, r],
      [r32,     r32|m32] => [0x13, r]

  # Add
  ADD [eax,     imm32]   => [0x05, id],
      [r32|m32, imm32]   => [0x81, ?0, id],
      [r32|m32, imm8]    => [0x83, ?0, ib],
      [r32|m32, r32]     => [0x01, r],
      [r32,     r32|m32] => [0x03, r]

  # Logical AND
  AND [eax,     imm32]   => [0x25, id],
      [r32|m32, imm32]   => [0x81, ?4, id],
      [r32|m32, imm8]    => [0x83, ?4, ib],
      [r32|m32, r32]     => [0x21, r],
      [r32,     r32|m32] => [0x23, r]

  # Check Array Index Against Bounds
  BOUND [r16, m16&16] => [0x62, r],
        [r32, m32&32] => [0x62, r]

  # Call Procedure
  CALL [rel32]    => [0xE8, cd],
       [r32|m32]  => [0xFF, ?2],
       [ptr16^16] => [0x9A, cd],
       [ptr16^32] => [0x9A, cp],
       [m16^32]   => [0xFF, ?3]

  # Decrement by 1
  DEC [r32|m32] => [0xFF, ?1],
      [r32]     => [0x48, rd]

  # Unsigned Divide
  DIV [r32|m32] => [0xF7, ?6, id]
  # FIXME: this is wrong, investigate

  # Make Stack Frame for Procedure Parameters
  ENTER [imm16, imm8] => [0xC8, iw, ib]

  # Signed Divide
  IDIV [+r32|+m32] => [0xF7, ?7]

  # Signed Multiply
  IMUL [+r32|+m32]       => [0xF7, ?5],
       [+r32, +r32|+m32] => [0x0F, 0xAF, r],
}]
