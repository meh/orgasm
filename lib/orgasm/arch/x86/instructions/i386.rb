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
  # Bit Scan Forward
  BSF [r16, r16|m16] => [0x0F, 0xBC],
      [r32, r32|m32] => [0x0F, 0xBC]
  
  # Bit Scan Reverse
  BSR [r16, r16|m16] => [0x0F, 0xBD],
      [r32, r32|m32] => [0x0F, 0xBD]

  # Bit Test
  BT [r16|m16, r16]  => [0x0F, 0xA3],
     [r32|m32, r32]  => [0x0F, 0xA3],
     [r16|m16, imm8] => [0x0F, 0xBA, ?4, ib],
     [r32|m32, imm8] => [0x0F, 0xBA, ?4, ib]

  # Bit Test and Complement
  BTC [r16|m16, r16]  => [0x0F, 0xBB],
      [r32|m32, r32]  => [0x0F, 0xBB],
      [r16|m16, imm8] => [0x0F, 0xBA, ?7, ib],
      [r32|m32, imm8] => [0x0F, 0xBA, ?7, ib]

  # Bit Test and Reset
  BTR [r16|m16, r16]  => [0x0F, 0xB3],
      [r32|m32, r32]  => [0x0F, 0xB3],
      [r16|m16, imm8] => [0x0F, 0xBA, ?6, ib],
      [r32|m32, imm8] => [0x0F, 0xBA, ?6, ib]

  # Call Procedure
  CALL [rel16]    => [0xE8, cw],
       [rel32]    => [0xE8, cd],
       [r16|m16]  => [0xFF, ?2],
       [r32|m32]  => [0xFF, ?2],
       [ptr16^16] => [0x9A, cd],
       [ptr16^32] => [0x9A, cp],
       [m16^16]   => [0xFF, ?3],
       [m16^32]   => [0xFF, ?3]

  # Convert Byte to Word
  CBW [ax].ignore => [0x98]

  # Convert Word to Doubleword
  CWDE [eax].ignore => [0x98]
        
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
  CMP [al, imm8]       => [0x3C, ib],
      [ax, imm16]      => [0x3D, iw],
      [eax, imm32]     => [0x3D, id],
      [r8|m8, imm8]    => [0x80, ?7, ib],
      [r16|m16, imm16] => [0x81, ?7, iw],
      [r32|m32, imm32] => [0x81, ?7, id],
      [r16|m16, imm8]  => [0x83, ?7, ib],
      [r32|m32, imm8]  => [0x83, ?7, ib],
      [r8|m8, r8]      => [0x38, r],
      [r16|m16, r16]   => [0x39, r],
      [r32|m32, r32]   => [0x39, r],
      [r8, r8|m8]      => [0x3A, r],
      [r16, r16|m16]   => [0x3B, r],
      [r32, r32|m32]   => [0x3B, r]

  # Compare String Operands
  CMPS [m8, m8]   => [0xA6],
       [m16, m16] => [0xA7],
       [m32, m32] => [0xA7]

  CMPSB [0xA6]

  CMPSW [ax].ignore => [0xA7]

  CMPSD [eax].ignore => [0xA7]

  # -- x87 FPU --
=begin

  # Packed Single-FP Add
  ADDPS [xmm1, xmm2|m128] => [0x0F, 0x58, r]

  # Scalar Single-FP Add
  ADDSS [xmm1, xmm2|m32] => [0xF3, 0x0F, 0x58, r]

  # Bit-wise Logical And ot For Single-FP
  ANDNPS [xmm1, xmm2|m128] => [0x0F, 0x55, r]

  # Bit-wise Logical And For Single FP
  ANDPS [xmm1, xmm2|m128] => [0x0F, 0x54, r]

  CMPPS [xmm1, xmm2|m128, imm8] => [0x0F, 0xC2, r, ib]

  CMPSS [xmm1, xmm2|m32, imm8] => [0xF3, 0x0F, 0xC2, r, ib]
=end
}.to_hash]
