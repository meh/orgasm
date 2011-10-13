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
	IRET [ax].ignore => [0xCF]

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

	# Assert LOCK# Signal Prefix
	LOCK [0xF0]

	# Load String
	LODSB [0xAC]

	LODSW [ax].ignore => [0xAD]

	# Loop According to ECX Counter
	LOOP [rel8] => [0xE2, +cb]

	LOOPE [rel8] => [0xE1, +cb]

	LOOPZ [rel8] => [0xE1, +cb]

	LOOPNE [rel8] => [0xE0, +cb]

	LOOPNZ [rel8] => [0xE0, +cb]
}]
