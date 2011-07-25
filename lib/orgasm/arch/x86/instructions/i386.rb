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

  # Conver Doubleword to Quadword
  CDQ [eax].ignore => [0x99]
       
  # Compare Two Operands
  CMP [eax,     imm32]   => [0x3D, id],
      [r32|m32, imm32]   => [0x81, ?7, id],
      [r32|m32, imm8]    => [0x83, ?7, ib],
      [r32|m32, r32]     => [0x39, r],
      [r32,     r32|m32] => [0x3B, r]

  # Compare String Operands
  CMPS [m8, m8]   => [0xA6],
       [m16, m16] => [0xA7],
       [m32, m32] => [0xA7]

  CMPSD [eax].ignore => [0xA7]

  # Convert Word to Doubleword
  CWDE [eax].ignore => [0x98]
 
}.to_hash]