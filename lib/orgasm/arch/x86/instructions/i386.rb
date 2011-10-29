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
	    [r32|m32, imm8]    => [0x83, ?2, +ib],
	    [r32|m32, r32]     => [0x11, r],
	    [r32,     r32|m32] => [0x13, r]

	# Add
	ADD [eax,     imm32]   => [0x05, id],
	    [r32|m32, imm32]   => [0x81, ?0, id],
	    [r32|m32, imm8]    => [0x83, ?0, +ib],
	    [r32|m32, r32]     => [0x01, r],
	    [r32,     r32|m32] => [0x03, r]

	# Logical AND
	AND [eax,     imm32]   => [0x25, id],
	    [r32|m32, imm32]   => [0x81, ?4, id],
	    [r32|m32, imm8]    => [0x83, ?4, +ib],
	    [r32|m32, r32]     => [0x21, r],
	    [r32,     r32|m32] => [0x23, r]

	# Check Array Index Against Bounds
	BOUND [r32, m32&32] => [0x62, r]


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

	# Decrement by 1
	DEC [r32|m32] => [0xFF, ?1],
	    [r32]     => [0x48, rd]

	# Unsigned Divide
	DIV [r32|m32] => [0xF7, ?6, id]

	# Signed Divide
	IDIV [r32|m32] => [0xF7, ?7]

	# Signed Multiply
	IMUL [r32|m32]             => [0xF7, ?5],
	     [r32, r32|m32]        => [0x0F, 0xAF, r],
	     [r32, r32|m32, imm8]  => [0x6B, r, +ib],
	     [r32, imm8]           => [0x6B, r, +ib],
	     [r32, r32|m32, imm16] => [0x69, r, +id]

	# Input from Port
	IN [eax, imm8] => [0xE5, ib],
	   [eax, dx]   => [0xED]

	# Increment by 1
	INC [r32|m32] => [0xFF, ?0],
	    [r32]     => [0x40, rd]

	# Input from Port to String
	INS [m32, dx] => [0x6D]

	# Input from Port to String
	INSB [0x6C]

	INSW [ax].ignore => [0x6D]

	INSD [eax].ignore => [0x6D]

	# Interrupt Return
	IRETD [eax].ignore => [0xCF]

	# Jump if Condition Is Met
	JA [rel32] => [0x0F, 0x87, +cd]

	JAE [rel32] => [0x0F, 0x83, +cd]

	JB [rel32] => [0x0F, 0x82, +cd]

	JBE [rel32] => [0x0F, 0x86, +cd]

	JC [rel32] => [0x0F, 0x82, +cd]

	JE [rel32] => [0x0F, 0x84, +cd]

	JG [rel32] => [0x0F, 0x8F, +cd]

	JGE [rel32] => [0x0F, 0x8D, +cd]

	JL [rel32] => [0x0F, 0x8C, +cd]

	JLE [rel32] => [0x0F, 0x8E, +cd]

	JNA [rel32] => [0x0F, 0x86, +cd]

	JNAE [rel32] => [0x0F, 0x82, +cd]

	JNB [rel32] => [0x0F, 0x83, +cd]

	JNBE [rel32] => [0x0F, 0x87, +cd]

	JNC [rel32] => [0x0F, 0x83, +cd]

	JNE [rel32] => [0x0F, 0x85, +cd]

	JNG [rel32] => [0x0F, 0x8E, +cd]

	JNGE [rel32] => [0x0F, 0x8C, +cd]

	JNL [rel32] => [0x0F, 0x8D, +cd]

	JNLE [rel32] => [0x0F, 0x8F, +cd]

	JNO [rel32] => [0x0F, 0x81, +cd]

	JNP [rel32] => [0x0F, 0x8B, +cd]

	JNS [rel32] => [0x0F, 0x89, +cd]

	JNZ [rel32] => [0x0F, 0x85, +cd]

	JO [rel32] => [0x0F, 0x80, +cd]

	JP [rel32] => [0x0F, 0x8A, +cd]

	JPE [rel32] => [0x0F, 0x8A, +cd]

	JPO [rel32] => [0x0F, 0x8B, +cd]

	JS [rel32] => [0x0F, 0x88, +cd]

	JZ [rel32] => [0x0F, 0x84, +cd]

	# Jump
	# TODO: the various *:(16|32), still don't know how to proceed with those
	JMP [rel32]   => [0xE9, +cd],
	    [r32|m32] => [0xFF, ?4]

	# Load Access Rights Byte
	LAR [r32, r32|m32] => [0x0F, 0x02, r]

	# Load Effective Address
	LEA [r32, m] => [0x8D, r]

	# High Level Procedure Exit
	LEAVE [eax].ignore => [0xC9]

	# Load String
	LODSD [eax].ignore => [0xAD]

	# Load Segment Limit
	LSL [r32, r32|m32] => [0x0F, 0x03, r]

	# Load Full Pointer
	# LSS
	
	# Move
	MOV [r32|m32, r32]     => [0x89, r],
	    [r32,     r32|m32] => [0x8B, r],
	    [eax,     moffs32] => [0xA1, cd],
	    [moffs32, eax]     => [0xA3, cd],
	    [r32,     imm32]   => [0xB8, rd],
	    [r32|m32, imm32]   => [0xC7, ?0],

	# Move to/from Control Registers
	    [cr0, r32] => [0x0F, 0x22, r],
	    [cr2, r32] => [0x0F, 0x22, r],
	    [cr3, r32] => [0x0F, 0x22, r],
	    [cr4, r32] => [0x0F, 0x22, r],
	    [r32, cr0] => [0x0F, 0x20, r],
	    [r32, cr2] => [0x0F, 0x20, r],
	    [r32, cr3] => [0x0F, 0x20, r],
	    [r32, cr4] => [0x0F, 0x20, r],

	# Move to/from Debug Registers
	    [r32, dr]  => [0x0F, 0x21, r],
	    [dr,  r32] => [0x0F, 0x23, r]

	# Move Data from String to String
	MOVS [m32, m32].ignore => [0xA5]

	MOVSD [eax].ignore => [0xA5]

	# Move with Zero-Extended
	MOVZX [r16, r8|m8]   => [0x0F, 0xB6, r],
	      [r32, r8|m8]   => [0x0F, 0xB6, r],
	      [r32, r16|m16] => [0x0F, 0xB7, r]

	# Unsigned Multiply
	MUL [r32|m32] => [0xF7, ?4]

	# Two's Complement Negation
	NEG [r32|m32] => [0xF7, ?3]

	# One's Complement Negation
	NOT [r32|m32] => [0xF7, ?2]

	# Logical Inclusive OR
	OR [eax,     imm32]   => [0x0D, id],
	   [r32|m32, imm32]   => [0x81, ?1, id],
	   [r32|m32, imm8]    => [0x83, ?1, +ib],
	   [r32|m32, r32]     => [0x09, r],
	   [r32,     r32|m32] => [0x0B, r]

	# Output String to Port
	OUTS [dx, m32] => [0x6F]

	OUTSD [eax].ignore => [0x6F]

	# Pop a Value from the Stack
	POP [m32] => [0x8F, ?0],
	    [r32] => [0x58, +rd]

	# Pop All General-Purpose Registers
	POPAD [eax].ignore => [0x61]

	# Pop Stack into EFLAGS Register
	POPFD [eax].ignore => [0x9D]

	# Push all General-Purpose Registers
	PUSHAD [eax].ignore => [0x60]

	# Push EFLAGS Register onto the Stack
	PUSHFD [eax].ignore => [0x9C]

	# Rotate
	RCL [r32|m32,   1]    => [0xD1, ?2],
	    [r32|m32,   cl]   => [0xD3, ?2],
	    [r32|m32,   imm8] => [0xC1, ?2, ib]

	RCR [r32|m32,   1]    => [0xD1, ?3],
	    [r32|m32,   cl]   => [0xD3, ?3],
	    [r32|m32,   imm8] => [0xC1, ?3, ib]

	ROL [r32|m32,   1]    => [0xD1, ?0],
	    [r32|m32,   cl]   => [0xD3, ?0],
	    [r32|m32,   imm8] => [0xC1, ?0, ib]

	ROR [r32|m32,   1]    => [0xD1, ?1],
	    [r32|m32,   cl]   => [0xD3, ?1],
	    [r32|m32,   imm8] => [0xC1, ?1, ib]

	# Shift
	SAL [r32|m32, 1]    => [0xD1, ?4],
	    [r32|m32, cl]   => [0xD3, ?4],
	    [r32|m32, imm8] => [0xC1, ?4, ib]

	SAR [r32|m32, 1]    => [0xD1, ?7],
	    [r32|m32, cl]   => [0xD3, ?7],
	    [r32|m32, imm8] => [0xC1, ?7, ib]

	SHL [r32|m32, 1]    => [0xD1, ?4],
	    [r32|m32, cl]   => [0xD3, ?4],
	    [r32|m32, imm8] => [0xC1, ?4, ib]

	SHR [r32|m32, 1]    => [0xD1, ?5],
	    [r32|m32, cl]   => [0xD3, ?5],
	    [r32|m32, imm8] => [0xC1, ?5, ib]

	# Integer Substraction with Borrow
	SBB [eax,     imm32]   => [0x1D, id],
	    [r32|m32, imm32]   => [0x81, ?3, id],
	    [r32|m32, imm8]    => [0x83, ?3, +ib],
	    [r32|m32, r32]     => [0x19, r],
	    [r32,     r32|m32] => [0x1B, r]

	# Scan String
	SCAS [m32] => [0xAF]

	SCASD [0xAF]

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

	# Store Local Descriptor Table Register
	SLDT [r32|m32] => [0x0F, 0x00, ?0]

	SMSW [r32|m16] => [0x0F, 0x01, ?4]

	# Store String
	STOS [m32] => [0xAB]

	STOSD [0xAB]

	# Substract
	SUB [eax,     imm32]   => [0x2D, id],
	    [r32|m32, imm32]   => [0x81, ?5, id],
	    [r32|m32, imm8]    => [0x83, ?5, +ib],
	    [r32|m32, r32]     => [0x29, r],
	    [r32,     r32|m32] => [0x2B, r]

	# Logical Compare
	TEST [eax,     imm32] => [0xA9, id],
	     [r32|m32, imm32] => [0xF7, ?0, id],
	     [r32|m32, r32]   => [0x85, r]

	# Logical Exclusive OR
	XOR [eax,     imm32]   => [0x35, id],
	    [r32|m32, imm32]   => [0x81, ?6, id],
	    [r32|m32, imm8]    => [0x83, ?6, +ib],
	    [r32|m32, r32]     => [0x31, r],
	    [r32,     r32|m32] => [0x33, r]
}.to_hash]
