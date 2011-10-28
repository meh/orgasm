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
	INS [m8, dx]  => [0x6C],
	    [m16, dx] => [0x6D],
	    [m32, dx] => [0x6D]

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

	# Load Effective Address
	LEA [r32, m] => [0x8D, r]

	# High Level Procedure Exit
	LEAVE [ax].ignore  => [0xC9],
	      [eax].ignore => [0xC9]

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

	# Output to Port
	OUT [imm8, eax] => [0xE7, ib],
	    [dx,   eax] => [0xEF]

	# Output String to Port
	OUTS [dx, m8]  => [0x6E],
	     [dx, m16] => [0x6F],
	     [dx, m32] => [0x6F]

	OUTSB [al].ignore => [0x6E]

	OUTSW [ax].ignore => [0x6F]

	OUTSD [eax].ignore => [0x6F]

	# Pop a Value from the Stack
	POP [m32] => [0x8F, ?0],
	    [r32] => [0x58, +rd]

	# Pop All General-Purpose Registers
	POPA [ax].ignore => [0x61]

	# Pop Stack into EFLAGS Register
	POPFD [eax].ignore => [0x9D]

	# Push all General-Purpose Registers
	PUSHA [ax].ignore => [0x60]

	# Push EFLAGS Register onto the Stack
	PUSHFD [eax].ignore => [0x9C]

	# Repeat String Operation Prefix
	REP [0xF3, [0x6C]],
	    [0xF3, [0x6D]],
	    [0xF3, [0x6E]],
	    [0xF3, [0x6F]]

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
}]
