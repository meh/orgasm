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

SIMD::X86::Instructions[SIMD::X86::DSL.new {
	# Empty MMX™ State
	EMMS [0x0F, 0x77]

	# Move 32 Bits
	MOVD [mm,      r32|m32] => [0x0F, 0x6E, r],
	     [r32|m32, mm]      => [0x0F, 0x7E, r]

	# Move 64 Bits
	MOVQ [mm,     mm|m64] => [0x0F, 0x6F, r],
	     [mm|m64, mm]     => [0x0F, 0x7F, r]

	# Pack wih Signed Saturation
	PACKSSWB [mm, mm|m64] => [0x0F, 0x63, r]

	PACKSSDW [mm, mm|m64] => [0x0F, 0x6B, r]

	# Pack with Unsigned Saturation
	PACKUSWB [mm, mm|m64] => [0x0F, 0x67, r]

	# Packed Add
	PADDB [mm, mm|m64] => [0x0F, 0xFC, r]

	PADDW [mm, mm|m64] => [0x0F, 0xFD, r]

	PADDD [mm, mm|m64] => [0x0F, 0xFE, r]

	# Packed Add with Saturation
	PADDSB [mm, mm|m64] => [0x0F, 0xEC, r]

	PADDSW [mm, mm|m64] => [0x0F, 0xED, r]

	# Packed Add Unsigned with Saturation
	PADDUSB [mm, mm|m64] => [0x0F, 0xDC, r]

	PADDUSW [mm, mm|m64] => [0x0F, 0xDD, r]

	# Logical AND
	PAND [mm, mm|m64] => [0x0F, 0xDB, r]

	# Logical AND NOT
	PANDN [mm, mm|m64] => [0x0F, 0xDF, r]

	# Packed Compare for Equal
	PCMPEQB [mm, mm|m64] => [0x0F, 0x74, r]

	PCMPEQW [mm, mm|m64] => [0x0F, 0x75, r]

	PCMPEQD [mm, mm|m64] => [0x0F, 0x76, r]

	# Packed Compare for Greater
	PCMPGTB [mm, mm|m64] => [0x0F, 0x64, r]

	PCMPGTW [mm, mm|m64] => [0x0F, 0x65, r]

	PCMPGTD [mm, mm|m64] => [0x0F, 0x66, r]

	# Packed Multiply and Add
	PMADDWD [mm, mm|m64] => [0x0F, 0xF5, r]

	# Packed Multiply High
	PMULHW [mm, mm|m64] => [0x0F, 0xE5, r]

	# Packed Multiply Low
	PMULLW [mm, mm|m64] => [0x0F, 0xD5, r]

	# Bitwise Logical OR
	POR [mm, mm|m64] => [0x0F, 0xEB, r]

	# Packed Shift Left Logical
	PSLLW [mm, mm|m64] => [0x0F, 0xF1, r],
	      [mm, imm8]   => [0x0F, 0x71, ?6, ib]

	PSLLD [mm, mm|m64] => [0x0F, 0xF2, r],
	      [mm, imm8]   => [0x0F, 0x72, ?6, ib]

	PSLLQ [mm, mm|m64] => [0x0F, 0xF3, r],
	      [mm, imm8]   => [0x0F, 0x73, ?6, ib]

	# Packed Shift Right Arithmetic
	PSRAW [mm, mm|m64] => [0x0F, 0xE1, r],
	      [mm, imm8]   => [0x0F, 0x71, ?4, ib]

	PSRAD [mm, mm|m64] => [0x0F, 0xE2, r],
	      [mm, imm8]   => [0x0F, 0x72, ?4, ib]

	# Packed Shift Right Logical
	PSRLW [mm, mm|m64] => [0x0F, 0xD1, r],
	      [mm, imm8]   => [0x0F, 0x71, ?2, ib]

	PSRLD [mm, mm|m64] => [0x0F, 0xD2, r],
	      [mm, imm8]   => [0x0F, 0x72, ?2, ib]

	PSRLQ [mm, mm|m64] => [0x0F, 0xD3, r],
	      [mm, imm8]   => [0x0F, 0x73, ?2, ib]

	# Packed Substract
	PSUBB [mm, mm|m64] => [0x0F, 0xF8, r]

	PSUBW [mm, mm|m64] => [0x0F, 0xF9, r]

	PSUBD [mm, mm|m64] => [0x0F, 0xFA, r]

	# Packed Substract with Saturation
	PSUBSB [mm, mm|m64] => [0x0F, 0xE8, r]

	PSUBSW [mm, mm|m64] => [0x0F, 0xE9, r]

	# Packed Substract Unsigned with Saturation
	PSUBUSB [mm, mm|m64] => [0x0F, 0xD8, r]

	PSUBUSW [mm, mm|m64] => [0x0F, 0xD9, r]

	# Unpack High Packed
	PUNPCKHBW [mm, mm|m64] => [0x0F, 0x68, r]

	PUNPCKHWD [mm, mm|m64] => [0x0F, 0x69, r]

	PUNPCKHDQ [mm, mm|m64] => [0x0F, 0x6A, r]

	# Unpack Low Packed
	PUNPCKLBW [mm, mm|m32] => [0x0F, 0x60, r]

	PUNPCKLWD [mm, mm|m32] => [0x0F, 0x61, r]

	PUNPCKLDQ [mm, mm|m32] => [0x0F, 0x62, r]

	# Logical Exclusive OR
	PXOR [mm, mm|m64] => [0x0F, 0xEF, r]
}]
