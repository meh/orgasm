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

X87::Instructions[X87::DSL.new {
	# Compute 2^x-1
	F2XM1 [0xD9, 0xF0]

	# Absolute Value
	FABS [0xD9, 0xE1]

	# Add
	FADD [m32real]  => [0xD8, ?0],
	     [m64real]  => [0xDC, ?0],
	     [st0, sti] => [0xD8, 0xC0, i],
	     [sti, st0] => [0xDC, 0xC0, i]

	FADDP [0xDE, 0xC1],
	      [sti, st0] => [0xDE, 0xC0, i]

	FIADD [m32int] => [0xDA, ?0],
	      [m64int] => [0xDE, ?0]

	# Load binary Coded Decimal
	FBLD [m80dec] => [0xDF, ?4]

	# Store BCD Integer and Pop
	FBSTP [m80bcd] => [0xDF, ?6]

	# Change Sign
	FCHS [0xD9, 0xE0]

	# Clear Exceptions
	FCLEX [0x9B, 0xDB, 0xE2]

	FNCLEX [0xDB, 0xE2]

	# Compare Real
	FCOM [0xD8, 0xD1],
	     [m32real] => [0xD8, ?2],
	     [m64real] => [0xDC, ?2],
	     [sti]     => [0xD8, 0xD0, i]

	FCOMP [0xD8, 0xD9],
	      [m32real] => [0xD8, ?3],
	      [m64real] => [0xDC, ?3],
	      [sti]     => [0xD8, 0xD8, i]

	FCOMPP [0xDE, 0xD9]

	# Decrement Stack-Top Pointer
	FDECSTP [0xD9, 0xF6]

	# Divide
	FDIV [m32real]  => [0xD8, ?6],
	     [m64real]  => [0xDC, ?6],
	     [st0, sti] => [0xD8, 0xF0, i],
	     [sti, st0] => [0xDC, 0xF8, i]

	FDIVP [0xDE, 0xF9],
	      [sti, st0] => [0xDE, 0xF8, i]

	FIDIV [m32int] => [0xDA, ?6],
	      [m64int] => [0xDE, ?6]

	# Reverse Divide
	FDIVR [m32real]  => [0xD8, ?7],
	      [m64real]  => [0xDC, ?7],
	      [st0, sti] => [0xD8, 0xF8, i],
	      [sti, st0] => [0xDC, 0xF0, i]

	FDIVRP [0xDE, 0xF1],
	       [sti, st0] => [0xDE, 0xF0, i]

	FIDIVR [m32int] => [0xDA, ?7],
	       [m64int] => [0xDE, ?7]

	# Free Floating-Pointer Register
	FFREE [sti] => [0xDD, 0xC0, i]

	# Compare Integer
	FICOM [m16int] => [0xDE, ?2],
	      [m32int] => [0xDA, ?2]

	FICOMP [m16int] => [0xDE, ?3],
	       [m32int] => [0xDA, ?3]

	# Load Integer
	FILD [m16int] => [0xDF, ?0],
	     [m32int] => [0xDB, ?0],
	     [m64int] => [0xDF, ?5]

	# Increment Stack-Top Pointer
	FINCSTP [0xD9, 0xF7]

	# Initialize Floating-Point Unit
	FINIT [0x9B, 0xDB, 0xE3]

	FNINIT [0xDB, 0xE3]

	FIST [m16int] => [0xDF, ?2],
	     [m32int] => [0xDB, ?2]

	FISTP [m16int] => [0xDF, ?3],
	      [m32int] => [0xDB, ?3],
	      [m64int] => [0xDF, ?7]

	# Load Real
	FLD [m32real] => [0xD9, ?0],
	    [m64real] => [0xDD, ?0],
	    [m80real] => [0xDB, ?5],
	    [sti]     => [0xD9, 0xC0, i]

	# Load Constant
	FLD1 [0xD9, 0xE8]

	FLDL2T [0xD9, 0xE9]

	FLDL2E [0xD9, 0xEA]

	FLDPI [0xD9, 0xEB]

	FLDLG2 [0xD9, 0xEC]

	FLDLN2 [0xD9, 0xED]

	FLDZ [0xD9, 0xEE]

	# Load Control Word
	FLDCW [m2byte] => [0xD9, ?5]

	# Load FPU Environment
	FLDENV [m14byte|m28byte] => [0xD9, ?4]

	# Multiply
	FMUL [m32real]  => [0xD8, ?1],
	     [m64real]  => [0xDC, ?1],
	     [st0, sti] => [0xD8, 0xC8, i],
	     [sti, st0] => [0xDC, 0xC8, i]

	FMULP [0xDE, 0xC9],
	      [sti, st0] => [0xDE, 0xC8, i]

	FIMUL [m32int] => [0xDA, ?1],
	      [m16int] => [0xDE, ?1]

	# No Operation
	FNOP [0xD9, 0xD0]

	# Partial Arctangent
	FPATAN [0xD9, 0xF3]

	# Partial Remainder
	FPREM [0xD9, 0xF8]

	# Partial Tangent
	FPTAN [0xD9, 0xF2]

	# Round to Integer
	FRNDINT [0xD9, 0xFC]

	# Restore FPU State
	FRSTOR [m94byte|m108byte] => [0xDD, ?4]

	# Store FPU State
	FSAVE [m94byte|m108byte] => [0x9B, 0xDD, ?6]

	FNSAVE [m94byte|m108byte] => [0xDD, ?6]

	# Scale
	FSCALE [0xD9, 0xFD]

	# Square Root
	FSQRT [0xD9, 0xFA]

	# Store Real
	FST [m32real] => [0xD9, ?2],
	    [m64real] => [0xDD, ?2],
	    [sti]     => [0xDD, 0xD0, i]

	FSTP [m32real] => [0xD9, ?3],
	     [m64real] => [0xDD, ?3],
	     [m80real] => [0xDB, ?7],
	     [sti]     => [0xDD, 0xD8, i]

	# Store Control Word
	FSTCW [m2byte] => [0x9B, 0xD9, ?7]

	FNSTCW [m2byte] => [0xD9, ?7]

	# Store FPU Environment
	FSTENV [m14byte|m28byte] => [0x9B, 0xD9, ?6]

	FNSTENV [m14byte|m28byte] => [0xD9, ?6]

	# Store Status Word
	FSTSW [m2byte] => [0x9B, 0xDD, ?7],
	      [ax]     => [0x9B, 0xDF, 0xE0]

	FNSTSW [m2byte] => [0xDD, ?7],
	       [ax]     => [0xDF, 0xE0]

	# Substract
	FSUB [m32real]  => [0xD8, ?4],
	     [m64real]  => [0xDC, ?4],
	     [st0, sti] => [0xD8, 0xE0, i],
	     [sti, st0] => [0xDC, 0xE8, i]

	FSUBP [0xDE, 0xE9],
	      [sti, st0] => [0xDE, 0xE8, i]

	FISUB [m32int] => [0xDA, ?4],
	      [m16int] => [0xDE, ?4]

	# Reverse Substract
	FSUBR [m32real] => [0xD8, ?5],
	      [m64real] => [0xDC, ?5],
	      [st0, sti] => [0xD8, 0xE8, i],
	      [sti, st0] => [0xDC, 0xE0, i]

	FSUBRP [0xDE, 0xE1],
	       [sti, st0] => [0xDE, 0xE0, i]

	FISUBR [m32int] => [0xDA, ?5],
	       [m16int] => [0xDE, ?5]

	# TEST
	FTST [0xD9, 0xE4]
	
	# Wait
	# FWAIT 
	# FIXME: refer to WAIT

	# Examine
	FXAM [0xD9, 0xE5]

	# Exchange Register Contents
	FXCH [0xD9, 0xC9],
	     [sti] => [0xD9, 0xC8, i]

	# Extract Exponent and Significand
	FXTRACT [0xD9, 0xF4]

	# Compute y = log2x
	FYL2X [0xD9, 0xF1]

	# Computer y = log2(x +1)
	FYL2XP1 [0xD9, 0xF9]
}]
