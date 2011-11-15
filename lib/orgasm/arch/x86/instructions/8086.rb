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
	    [r16|m16, imm8]    => [0x83, ?2, +ib],
	    [r8|m8,   r8]      => [0x10, r],
	    [r16|m16, r16]     => [0x11, r],
	    [r8,      r8|m8]   => [0x12, r],
	    [r16,     r16|m16] => [0x13, r]

	# Add
	ADD [al,      imm8]    => [0x04, ib],
	    [ax,      imm16]   => [0x05, iw],
	    [r8|m8,   imm8]    => [0x80, ?0, ib],
	    [r16|m16, imm16]   => [0x81, ?0, iw],
	    [r16|m16, imm8]    => [0x83, ?0, +ib],
	    [r8|m8,   r8]      => [0x00, r],
	    [r16|m16, r16]     => [0x01, r],
	    [r8,      r8|m8]   => [0x02, r],
	    [r16,     r16|m16] => [0x03, r]

	# Logical AND
	AND [al,      imm8]    => [0x24, ib],
	    [ax,      imm16]   => [0x25, iw],
	    [r8|m8,   imm8]    => [0x80, ?4, ib],
	    [r16|m16, imm16]   => [0x81, ?4, iw],
	    [r16|m16, imm8]    => [0x83, ?4, +ib],
	    [r8|m8,   r8]      => [0x20, r],
	    [r16|m16, r16]     => [0x21, r],
	    [r8,      r8|m8]   => [0x22, r],
	    [r16,     r16|m16] => [0x23, r]

	# Call Procedure
	CALL [rel16]    => [0xE8, cw],
	     [r16|m16]  => [0xFF, ?2]

	# Convert Byte to Word
	CBW hint(ax) => [0x98]

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
	    [r16|m16, imm8]    => [0x83, ?7, +ib],
	    [r8|m8,   r8]      => [0x38, r],
	    [r16|m16, r16]     => [0x39, r],
	    [r8,      r8|m8]   => [0x3A, r],
	    [r16,     r16|m16] => [0x3B, r]

	# Compare String Operands
	CMPSB [0xA6]

	CMPSW hint(ax) => [0xA7]

	# Convert Word to Doubleword
	CWD hint(ax) => [0x99]

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

	# Halt
	HLT [0xF4]

	# Signed Divide
	IDIV [r8|m8]   => [0xF6, ?7],
	     [r16|m16] => [0xF7, ?7]

	# Signed Multiply
	IMUL [r8|m8]               => [0xF6, ?5],
	     [r16|m16]             => [0xF7, ?5],
	     [r16, r16|m16]        => [0x0F, 0xAF, r],
	     [r16, r16|m16, imm8]  => [0x6B, r, +ib],
	     [r16, imm8]           => [0x6B, r, +ib],
	     [r16, r16|m16, imm16] => [0x69, r, +iw]

	# Input from Port
	IN [al, imm8] => [0xE4, ib],
	   [ax, imm8] => [0xE5, ib],
	   [al, dx]   => [0xEC],
	   [ax, dx]   => [0xED]

	# Increment by 1
	INC [r8|m8]   => [0xFE, ?0],
	    [r16|m16] => [0xFF, ?0],
	    [r16]     => [0x40, rw]

	# Call to Interrupt Procedure
	INT [imm8] => [0xCD, ib]

	INT3 [0xCC]

	INTO [0xCE]

	# Interrupt Return
	IRET hint(ax) => [0xCF]

	# Jump if Condition Is Met
	JA [rel8]  => [0x77, +cb],
	   [rel16] => [0x0F, 0x87, +cw]

	JAE [rel8]  => [0x73, +cb],
	    [rel16] => [0x0F, 0x83, +cw]

	JB [rel8]  => [0x72, +cb],
	   [rel16] => [0x0F, 0x82, +cw]

	JBE [rel8]  => [0x76, +cb],
	    [rel16] => [0x0F, 0x86, +cw]

	JC [rel8]  => [0x72, +cb],
	   [rel16] => [0x0F, 0x82, +cw]

	JCXZ [rel8] => [0xE3, +cb]

	JECXZ [rel8] => [0xE3, +cb]

	JE [rel8]  => [0x74, +cb],
	   [rel16] => [0x0F, 0x84, +cw]

	JG [rel8]  => [0x7F, +cb],
	   [rel16] => [0x0F, 0x8F, +cw]

	JGE [rel8]  => [0x7D, +cb],
	    [rel16] => [0x0F, 0x8D, +cw]

	JL [rel8]  => [0x7C, +cb],
	   [rel16] => [0x0F, 0x8C, +cw]

	JLE [rel8]  => [0x7E, +cb],
	    [rel16] => [0x0F, 0x8E, +cw]

	JNA [rel8]  => [0x76, +cb],
	    [rel16] => [0x0F, 0x86, +cw]

	JNAE [rel8]  => [0x72, +cb],
	     [rel16] => [0x0F, 0x82, +cw]

	JNB [rel8]  => [0x73, +cb],
	    [rel16] => [0x0F, 0x83, +cw]

	JNBE [rel8]  => [0x77, +cb],
	     [rel16] => [0x0F, 0x87, +cw]

	JNC [rel8]  => [0x73, +cb],
	    [rel16] => [0x0F, 0x83, +cw]

	JNE [rel8]  => [0x75, +cb],
	    [rel16] => [0x0F, 0x85, +cw]

	JNG [rel8]  => [0x7E, +cb],
	    [rel16] => [0x0F, 0x8E, +cw]

	JNGE [rel8]  => [0x7C, +cb],
	     [rel16] => [0x0F, 0x8C, +cw]

	JNL [rel8]  => [0x7D, +cb],
	    [rel16] => [0x0F, 0x8D, +cw]

	JNLE [rel8]  => [0x7F, +cb],
	     [rel16] => [0x0F, 0x8F, +cw]

	JNO [rel8]  => [0x71, +cb],
	    [rel16] => [0x0F, 0x81, +cw]

	JNP [rel8]  => [0x7B, +cb],
	    [rel16] => [0x0F, 0x8B, +cw]

	JNS [rel8]  => [0x79, +cb],
	    [rel16] => [0x0F, 0x89, +cw]

	JNZ [rel8]  => [0x75, +cb],
	    [rel16] => [0x0F, 0x85, +cw]

	JO [rel8]  => [0x70, +cb],
	   [rel16] => [0x0F, 0x80, +cw]

	JP [rel8]  => [0x7A, +cb],
	   [rel16] => [0x0F, 0x8A, +cw]

	JPE [rel8]  => [0x7A, +cb],
	    [rel16] => [0x0F, 0x8A, +cw]

	JPO [rel8]  => [0x7B, +cb],
	    [rel16] => [0x0F, 0x8B, +cw]

	JS [rel8]  => [0x78, +cb],
	   [rel16] => [0x0F, 0x88, +cw]

	JZ [rel8]  => [0x74, +cb],
	   [rel16] => [0x0F, 0x84, +cw]

	# Jump
	# TODO: the various *:(16|32), still don't know how to proceed with those
	JMP [rel8]    => [0xEB, +cb],
	    [rel16]   => [0xE9, +cw],
	    [r16|m16] => [0xFF, ?4]

	# Load Status Flags into AH Register
	LAHF [0x9F]

	# Load pointer using DS
	LDS [r16, m16] => [0xC5, r]

	# Load Effective Address
	LEA [r16, m16] => [0x8D, r]

	# Load ES with pointer
	LES [r16, m16] => [0xC4, r]

	# Load String
	LODSB [0xAC]

	LODSW hint(ax) => [0xAD]

	# Loop According to ECX Counter
	LOOP [rel8] => [0xE2, +cb]

	LOOPE [rel8] => [0xE1, +cb]

	LOOPZ [rel8] => [0xE1, +cb]

	LOOPNE [rel8] => [0xE0, +cb]

	LOOPNZ [rel8] => [0xE0, +cb]

	# Move
	MOV [r8|m8,   r8]      => [0x88, r],
	    [r16|m16, r16]     => [0x89, r],
	    [r8,      r8|m8]   => [0x8A, r],
	    [r16,     r16|m16] => [0x8B, r],
	    [r16|m16, sreg]    => [0x8C, r],
	    [sreg,    r16|m16] => [0x8E, r],
	    [al,      moffs8]  => [0xA0, cb],
	    [ax,      moffs16] => [0xA1, cw],
	    [moffs8,  al]      => [0xA2, cb],
	    [moffs16, ax]      => [0xA3, cw],
	    [r8,      imm8]    => [0xB0, rb, ib],
	    [r16,     imm16]   => [0xB8, rw, iw],
	    [r8|m8,   imm8]    => [0xC6, ?0, ib],
	    [r16|m16, imm16]   => [0xC7, ?0, iw]

	# Move Data from String to String
	MOVS hint(m8, m8)   => [0xA4],
	     hint(m16, m16) => [0xA5]

	MOVSB hint(al) => [0xA4]

	MOVSW hint(ax) => [0xA5]

	# Unsigned Multiply
	MUL [r8|m8]   => [0xF6, ?4],
	    [r16|m16] => [0xF7, ?4]

	# Two's Complement Negation
	NEG [r8|m8]   => [0xF6, ?3],
	    [r16|m16] => [0xF7, ?3]

	# No Operation
	NOP [0x90]

	# One's Complement Negation
	NOT [r8|m8]   => [0xF6, ?2],
	    [r16|m16] => [0xF7, ?2]

	# Logical Inclusive OR
	OR [al,      imm8]    => [0x0C, ib],
	   [ax,      imm16]   => [0x0D, iw],
	   [r8|m8,   imm8]    => [0x80, ?1, ib],
	   [r16|m16, imm16]   => [0x81, ?1, iw],
	   [r16|m16, imm8]    => [0x83, ?1, +ib],
	   [r8|m8,   r8]      => [0x08, r],
	   [r16|m16, r16]     => [0x09, r],
	   [r8,      r8|m8]   => [0x0A, r],
	   [r16,     r16|m16] => [0x0B, r]

	# Output to Port
	OUT [imm8, al] => [0xE6, ib],
	    [imm8, ax] => [0xE7, ib],
	    [dx,   al] => [0xEE],
	    [dx,   ax] => [0xEF]

	# Pop a Value from the Stack
	POP [m16] => [0x8F, ?0],
	    [r16] => [0x58, rw],
	    [ds]  => [0x1F],
	    [es]  => [0x07],
	    [ss]  => [0x17],
	    [fs]  => [0x0F, 0xA1],
	    [gs]  => [0x0F, 0xA9]

	# Pop Stack into EFLAGS Register
	POPF hint(ax) => [0x9D]

	# Push Word or Doubleword Onto the Stack
	PUSH [r16|m16] => [0xFF, ?6],
	     [r16]     => [0x50, rw],
	     [imm8]    => [0x6A, ib],
	     [imm16]   => [0x68, iw],
	     [cs]      => [0x0E],
	     [ss]      => [0x16],
	     [ds]      => [0x1E],
	     [es]      => [0x06],
	     [fs]      => [0x0F, 0xA0],
	     [gs]      => [0x0F, 0xA8]


	# Push EFLAGS Register onto the Stack
	PUSHF hint(ax) => [0x9C]

	# Rotate
	RCL [r8|m8,   1]    => [0xD0, ?2],
	    [r8|m8,   cl]   => [0xD2, ?2],
	    [r8|m8,   imm8] => [0xC0, ?2, ib],
	    [r16|m16, 1]    => [0xD1, ?2],
	    [r16|m16, cl]   => [0xD3, ?2],
	    [r16|m16, imm8] => [0xC1, ?2, ib]

	RCR [r8|m8,   1]    => [0xD0, ?3],
	    [r8|m8,   cl]   => [0xD2, ?3],
	    [r8|m8,   imm8] => [0xC0, ?3, ib],
	    [r16|m16, 1]    => [0xD1, ?3],
	    [r16|m16, cl]   => [0xD3, ?3],
	    [r16|m16, imm8] => [0xC1, ?3, ib]

	ROL [r8|m8,   1]    => [0xD0, ?0],
	    [r8|m8,   cl]   => [0xD2, ?0],
	    [r8|m8,   imm8] => [0xC0, ?0, ib],
	    [r16|m16, 1]    => [0xD1, ?0],
	    [r16|m16, cl]   => [0xD3, ?0],
	    [r16|m16, imm8] => [0xC1, ?0, ib]

	ROR [r8|m8,   1]    => [0xD0, ?1],
	    [r8|m8,   cl]   => [0xD2, ?1],
	    [r8|m8,   imm8] => [0xC0, ?1, ib],
	    [r16|m16, 1]    => [0xD1, ?1],
	    [r16|m16, cl]   => [0xD3, ?1],
	    [r16|m16, imm8] => [0xC1, ?1, ib]

	# Repeat String Operation Prefix
	REP [0xF3, [0xA4]],
	    [0xF3, [0xA5]],
	    [0xF3, [0xAC]],
	    [0xF3, [0xAA]],
	    [0xF3, [0xAB]]

	REPE [0xF3, [0xA6]],
	     [0xF3, [0xA7]],
	     [0xF3, [0xAE]],
	     [0xF3, [0xAF]]

	REPNE [0xF2, [0xA6]],
	      [0xF2, [0xA7]],
	      [0xF2, [0xAE]],
	      [0xF2, [0xAF]]
	
	# Return From Procedure
	RET [0xC3],
	    [imm16] => [0xC2, iw]

	RETF [0xCB],
	     [imm16] => [0xCA, iw]

	# Store AH into Flags
	SAHF [0x9E]

	# Shift
	SAL [r8|m8,   1]    => [0xD0, ?4],
	    [r8|m8,   cl]   => [0xD2, ?4],
	    [r8|m8,   imm8] => [0xC0, ?4, ib],
	    [r16|m16, 1]    => [0xD1, ?4],
	    [r16|m16, cl]   => [0xD3, ?4],
	    [r16|m16, imm8] => [0xC1, ?4, ib]

	SAR [r8|m8, 1]      => [0xD0, ?7],
	    [r8|m8, cl]     => [0xD2, ?7],
	    [r8|m8, imm8]   => [0xC0, ?7, ib],
	    [r16|m16, 1]    => [0xD1, ?7],
	    [r16|m16, cl]   => [0xD3, ?7],
	    [r16|m16, imm8] => [0xC1, ?7, ib]

	SHL [r8|m8, 1]      => [0xD0, ?4],
	    [r8|m8, cl]     => [0xD2, ?4],
	    [r8|m8, imm8]   => [0xC0, ?4, ib],
	    [r16|m16, 1]    => [0xD1, ?4],
	    [r16|m16, cl]   => [0xD3, ?4],
	    [r16|m16, imm8] => [0xC1, ?4, ib]

	SHR [r8|m8, 1]      => [0xD0, ?5],
	    [r8|m8, cl]     => [0xD2, ?5],
	    [r8|m8, imm8]   => [0xC0, ?5, ib],
	    [r16|m16, 1]    => [0xD1, ?5],
	    [r16|m16, cl]   => [0xD3, ?5],
	    [r16|m16, imm8] => [0xC1, ?5, ib]

	# Integer Substraction with Borrow
	SBB [al,      imm8]    => [0x1C, ib],
	    [ax,      imm16]   => [0x1D, iw],
	    [r8|m8,   imm8]    => [0x80, ?3, ib],
	    [r16|m16, imm16]   => [0x81, ?3, iw],
	    [r16|m16, imm8]    => [0x83, ?3, +ib],
	    [r8|m8,   r8]      => [0x18, r],
	    [r16|m16, r16]     => [0x19, r],
	    [r8,      r8|m8]   => [0x1A, r],
	    [r16,     r16|m16] => [0x1B, r]

	# Scan String
	SCAS [m8]  => [0xAE],
	     [m16] => [0xAF]

	SCASB [0xAE]

	SCASW [0xAF]

	# Set Carry Flag
	STC [0xF9]

	# Set Direction Flag
	STD [0xFD]

	# Set Interrupt Flag
	STI [0xFB]

	# Store String
	STOS [m8]  => [0xAA],
	     [m16] => [0xAB]

	STOSB hint(al) => [0xAA]

	STOSW hint(ax) => [0xAB]

	# Substract
	SUB [al,      imm8]    => [0x2C, ib],
	    [ax,      imm16]   => [0x2D, iw],
	    [r8|m8,   imm8]    => [0x80, ?5, ib],
	    [r16|m16, imm16]   => [0x81, ?5, iw],
	    [r16|m16, imm8]    => [0x83, ?5, +ib],
	    [r8|m8,   r8]      => [0x28, r],
	    [r16|m16, r16]     => [0x29, r],
	    [r8,      r8|m8]   => [0x2A, r],
	    [r16,     r16|m16] => [0x2B, r]

	# Logical Compare
	TEST [al,      imm8]  => [0xA8, ib],
	     [ax,      imm8]  => [0xA9, iw],
	     [r8|m8,   imm8]  => [0xF6, ?0, ib],
	     [r16|m16, imm16] => [0xF7, ?0, iw],
	     [r8|m8,   r8]    => [0x84, r],
	     [r16|m16, r16]   => [0x85, r]

	# Wait
	WAIT [0x9B]

	# Exchange Register/Memory with Register
	XCHG [ax,      r16]     => [0x90, +rw],
	     [r16,     ax]      => [0x90, +rw],
	     [r8|m8,   r8]      => [0x86, r],
	     [r8,      r8|m8]   => [0x86, r],
	     [r16|m16, r16]     => [0x87, r],
	     [r16,     r16|m16] => [0x87, r]

	# Table Look-up Translation
	XLAT [m8] => [0xD7]

	XLATB [0xD7]

	# Logical Exclusive OR
	XOR [al,      imm8]    => [0x34, ib],
	    [ax,      imm16]   => [0x35, iw],
	    [r8|m8,   imm8]    => [0x80, ?6, ib],
	    [r16|m16, imm16]   => [0x81, ?6, iw],
	    [r16|m16, imm8]    => [0x83, ?6, +ib],
	    [r8|m8,   r8]      => [0x30, r],
	    [r16|m16, r16]     => [0x31, r],
	    [r8,      r8|m8]   => [0x32, r],
	    [r16,     r16|m16] => [0x33, r]
}]
