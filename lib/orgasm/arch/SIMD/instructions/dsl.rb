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

require 'orgasm/arch/x87/instructions/dsl/special'

module Orgasm; module X87

class DSL
	Specials = [
		:mm,  :mm0,  :mm1,  :mm2,  :mm3,  :mm4,  :mm5,  :mm6,  :mm7,
		:xmm, :xmm0, :xmm1, :xmm2, :xmm3, :xmm4, :xmm5, :xmm6, :xmm7,

		# ?n # a digit between 0 ad 7 indicate that the ModR/M byte of the instruction
		     # uses only the r/m (register or memory) operand.
		     # The reg field contains the digit that provides an extension to the instruction's
		     # opcode.

		:r, # indicates that the ModR/M byte of the instruction contains both a register operand
		    # and an r/m operand.

		:r32, # one of the double-word general purpose registers: EAX, ECX, EDX, EBX, ESP, EBP, ESI, EDI

		:ib, # 1 byte

		:i, # a number used in floating-point instructions when one of the operands is ST(i) from the FPU
		    # register stack. The number i (which can range from 0 to 7) is added to the hexadecimal
		    # byte given at the left of the plus sign to form a single opcode byte.

		:imm8, # an immediate byte value. The imm8 symbol is a signed number between -128 and +127 inclusive.
		       # For instructins in which imm8 is combind with a word or doublewod operand, the immediate
		       # value is sign-extended to for a word or doubleword. The upper byte of the word is filled
		       # with the topmost bit of the immediate value

		:m32, # a doubleword operand in memory, usually expressed as a variable or array name, but pointed
		      # to by the DS:(E)SI or ES:(E)DI registers. This nomenclature is ued only with the string
		      # instructions

		:m64, # a memory quadword operand in memory. This nomenclaure is used only with the CMPXCHG8B instruction.

		:m128, # a memory double quadwrd operand in memory.

		:m32real, # a single-,double-, anextended-real (respectively) floating-point operand in memory
		:m64real,
		:m80real,

		:m16int, # a word-, short-, and long-integer (respectively) floating-point operand in memory
		:m32int,
		:m64int,

		:m80dec, # dunno
		:m80bcd,

		:m2byte,  # dunno
		:m14byte,
		:m28byte,
		:m94byte,
		:m108byte,

		:ST,  :st,  # the top element of the FPU register stack
		:ST0, :st0,

		:STi, :sti # the i^th element from the top of the FPU register stack. (i = 0 through 7)
	]

	def initialize (&block)
		@instructions = Hash.new {|hash, key| hash[key] = []}

		instance_eval &block
	end

	Specials.each {|special|
		define_method special do
			Special.new(special)
		end
	}

	def method_missing (id, *args)
		raise ArgumentError, "#{id} isn't supported" if args.empty?

		@instructions[id.to_sym.upcase].push(*args)
	end

	def to_hash
		@instructions
	end
end

end; end
