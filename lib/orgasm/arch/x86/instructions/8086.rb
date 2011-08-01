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

  # Add with Carry

  ADC [al,      imm8]    => [0x14, ib],
      [ax,      imm16]   => [0x15, iw],
      [r8|m8,   imm8]    => [0x80, ?2, ib],
      [r16|m16, imm16]   => [0x81, ?2, iw],
      [r16|m16, imm8]    => [0x83, ?2, ib],
      [r8|m8,   r8]      => [0x10, r],
      [r16|m16, r16]     => [0x11, r],
      [r8,      r8|m8]   => [0x12, r],
      [r16,     r16|m16] => [0x13, r]

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

  # Logical AND
  AND [al,      imm8]    => [0x24, ib],
      [ax,      imm16]   => [0x25, iw],
      [r8|m8,   imm8]    => [0x80, ?4, ib],
      [r16|m16, imm16]   => [0x81, ?4, iw],
      [r16|m16, imm8]    => [0x83, ?4, ib],
      [r8|m8,   r8]      => [0x20, r],
      [r16|m16, r16]     => [0x21, r],
      [r8,      r8|m8]   => [0x22, r],
      [r16,     r16|m16] => [0x23, r]

  # Call Procedure
  CALL [rel16]    => [0xE8, cw],
       [r16|m16]  => [0xFF, ?2]

  # Convert Byte to Word
  CBW [ax].ignore => [0x98]

  # Clear Carry Flag
  CLC [0xF8]

  # Clear Direction Flag
  CLD [0xFC]

  # Clear Interrupt Flag
  CLI [0xFA]

  # Clear Task-Switched Flag in CR0
  CLTS [0x0F, 0x06]

  # Complement Carry Flag
  CMC [0xF5]

  # Compare Two Operands
  CMP [al,      imm8]    => [0x3C, ib],
      [ax,      imm16]   => [0x3D, iw],
      [r8|m8,   imm8]    => [0x80, ?7, ib],
      [r16|m16, imm16]   => [0x81, ?7, iw],
      [r16|m16, imm8]    => [0x83, ?7, ib],
      [r8|m8,   r8]      => [0x38, r],
      [r16|m16, r16]     => [0x39, r],
      [r8,      r8|m8]   => [0x3A, r],
      [r16,     r16|m16] => [0x3B, r]

  # Compare String Operands
  CMPSB [0xA6]

  CMPSW [ax].ignore => [0xA7]

  # Convert Word to Doubleword
  CWD [ax].ignore => [0x99]

  # Decimal Adjust AL after Addition
  DAA [0x27]

  # Decimal Adjust AL after Substraction
  DAS [0x2F]

  # Decrement by 1
  DEC [r8|m8]   => [0xFE, ?1],
      [r16|m16] => [0xFF, ?1],
      [r16]     => [0x48, rw]

  # Unsigned Divide
  DIV [r8|m8]   => [0xF6, ?6],
      [r16|m16] => [0xF7, ?6]
  # FIXME: this is wrong, investigate
    
  # Halt
  HLT [0xF4]

  # Signed Divide
  IDIV [r8|m8]   => [0xF6, ?7],
       [r16|m16] => [0xF7, ?7]

  # Signed Multiply
  IMUL [r8|m8]               => [0xF6, ?5],
       [r16|m16]             => [0xF7, ?5],
       [r16, r16|m16]        => [0x0F, 0xAF, r],
       [r16, r16|m16, imm8]  => [0x6B, r, ib],
       [r16, imm8]           => [0x6B, r, ib],
       [r16, r16|m16, imm16] => [0x69, r, iw]
}]
