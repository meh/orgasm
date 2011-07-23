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

require 'orgasm/arch/i386/instructions/dsl'
require 'orgasm/arch/i386/instructions/instructions'

I386::Instructions[I386::DSL.new {
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
      [eax,     imm32]   => [0x15, id],
      [r8|m8,   imm8]    => [0x80, ?2, ib],
      [r16|m16, imm16]   => [0x81, ?2, iw],
      [r32|m32, imm32]   => [0x81, ?2, id],
      [r16|m16, imm8]    => [0x83, ?2, ib],
      [r32|m32, imm8]    => [0x83, ?2, ib],
      [r8|m8,   r8]      => [0x10, r],
      [r16|m16, r16]     => [0x11, r],
      [r32|m32, r32]     => [0x11, r],
      [r8,      r8|m8]   => [0x12, r],
      [r16,     r16|m16] => [0x13, r],
      [r32,     r32|m32] => [0x13, r]

  # Add
  ADD [al,      imm8]    => [0x04, ib],
      [ax,      imm16]   => [0x05, iw],
      [eax,     imm32]   => [0x05, id],
      [r8|m8,   imm8]    => [0x80, ?0, ib],
      [r16|m16, imm16]   => [0x81, ?0, iw],
      [r32|m32, imm32]   => [0x81, ?0, id],
      [r16|m16, imm8]    => [0x83, ?0, ib],
      [r32|m32, imm8]    => [0x83, ?0, ib],
      [r8|m8,   r8]      => [0x00, r],
      [r16|m16, r16]     => [0x01, r],
      [r32|m32, r32]     => [0x01, r],
      [r8,      r8|m8]   => [0x02, r],
      [r16,     r16|m16] => [0x03, r],
      [r32,     r32|m32] => [0x03, r]

  # Logical AND
  AND [al,      imm8]    => [0x24, ib],
      [ax,      imm16]   => [0x25, iw],
      [eax,     imm32]   => [0x25, id],
      [r8|m8,   imm8]    => [0x80, ?4, ib],
      [r16|m16, imm16]   => [0x81, ?4, iw],
      [r32|m32, imm32]   => [0x81, ?4, id],
      [r16|m16, imm8]    => [0x83, ?4, ib],
      [r32|m32, imm8]    => [0x83, ?4, ib],
      [r8|m8,   r8]      => [0x20, r],
      [r16|m16, r16]     => [0x21, r],
      [r32|m32, r32]     => [0x21, r],
      [r8,      r8|m8]   => [0x22, r],
      [r16,     r16|m16] => [0x23, r],
      [r32,     r32|m32] => [0x23, r]

  # Adjust RPL Field of Segment Selector
  ARPL [r16|m16, r16] => [0x63, r]

  # Check Array Index Against Bounds
  BOUND [r16, m16&16] => [0x62, r],
        [r32, m32&32] => [0x62, r]

  # Bit Scan Forward
  BFS [r16, r16|m16] => [0x0F, 0xBC],
      [r32, r32|m32] => [0x0F, 0xBC]
  
  # Bit Scan Reverse
  BSR [r16, r16|m16] => [0x0F, 0xBD],
      [r32, r32|m32] => [0x0F, 0xBD]

  # Byte Swap
  BSWAP [r32] => [0x0F, 0xC8, rd]
  # FIXME: not available on i386, only i486+

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
        

  # -- x87 FPU --

  # Packed Single-FP Add
  ADDPS [xmm1, xmm2|m128] => [0x0F, 0x58, r]

  # Scalar Single-FP Add
  ADDSS [xmm1, xmm2|m32] => [0xF3, 0x0F, 0x58, r]

  # Bit-wise Logical And ot For Single-FP
  ANDNPS [xmm1, xmm2|m128] => [0x0F, 0x55, r]

  # Bit-wise Logical And For Single FP
  ANDPS [xmm1, xmm2|m128] => [0x0F, 0x54, r]

}.to_hash]
