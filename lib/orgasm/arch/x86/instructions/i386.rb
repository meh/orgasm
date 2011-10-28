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

	# Input from Port to String
	INSB [0x6C]

	INSW [ax].ignore => [0x6D]

	INSD [eax].ignore => [0x6D]

	# Interrupt Return
	IRETD [eax].ignore => [0xCF]

	# Load String
	LODSD [eax].ignore => [0xAD]

	# Load Full Pointer
	# LSS
	
	# Move Data from String to String
	MOVS [m32, m32].ignore => [0xA5]

	MOVSD [eax].ignore => [0xA5]

	# Move with Zero-Extended
	MOVZX [r16, r8|m8]   => [0x0F, 0xB6, r],
	      [r32, r8|m8]   => [0x0F, 0xB6, r],
	      [r32, r16|m16] => [0x0F, 0xB7, r]

	# Pop All General-Purpose Registers
	POPAD [eax].ignore => [0x61]

	# Push all General-Purpose Registers
	PUSHAD [eax].ignore => [0x60]

	# Set Byte on Condition
	SETA [r8|m8] => [0x0F, 0x97]

	SETAE [r8|m8] => [0x0F, 0x93]

	SETB [r8|m8] => [0x0F, 0x92]

	SETBE [r8|m8] => [0x0F, 0x96]

	SETC [r8|m8] => [0x0F, 0x92]

	SETE [r8|m8] => [0x0F, 0x94]

	SETG [r8|m8] => [0x0F, 0x9F]

	SETGE [r8|m8] => [0x0F, 0x9D]

	SETL [r8|m8] => [0x0F, 0x9C]

	SETLE [r8|m8] => [0x0F, 0x9E]

	SETNA [r8|m8] => [0x0F, 0x96]

	SETNAE [r8|m8] => [0x0F, 0x92]

	SETNB [r8|m8] => [0x0F, 0x93]

	SETNBE [r8|m8] => [0x0F, 0x97]

	SETNC [r8|m8] => [0x0F, 0x93]

	SETNE [r8|m8] => [0x0F, 0x95]

	SETNG [r8|m8] => [0x0F, 0x9E]

	SETNGE [r8|m8] => [0x0F, 0x9C]

	SETNL [r8|m8] => [0x0F, 0x9D]

	SETNLE [r8|m8] => [0x0F, 0x9F]

	SETNO [r8|m8] => [0x0F, 0x91]

	SETNP [r8|m8] => [0x0F, 0x9B]

	SETNS [r8|m8] => [0x0F, 0x99]

	SETNZ [r8|m8] => [0x0F, 0x95]

	SETO [r8|m8] => [0x0F, 0x90]

	SETP [r8|m8] => [0x0F, 0x9A]

	SETPE [r8|m8] => [0x0F, 0x9A]

	SETPO [r8|m8] => [0x0F, 0x9B]

	SETS [r8|m8] => [0x0F, 0x98]

	SETZ [r8|m8] => [0x0F, 0x94]

	# Double Precision Shift Left
	SHLD [r16|m16, r16, imm8] => [0x0F, 0xA4, ib],
	     [r16|m16, r16, cl]   => [0x0F, 0xA5],
	     [r32|m32, r32, imm8] => [0x0F, 0xA4, ib],
	     [r32|m32, r32, cl]   => [0x0F, 0xA5]

	# Double Precision Shift Right
	SHRD [r16|m16, r16, imm8] => [0x0F, 0xAC, ib],
	     [r16|m16, r16, cl]   => [0x0F, 0xAD],
	     [r32|m32, r32, imm8] => [0x0F, 0xAC, ib],
	     [r32|m32, r32, cl]   => [0x0F, 0xAD]
}.to_hash]
