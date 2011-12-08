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

module Orgasm; module SIMD; module X86

class DSL
	Symbols = [
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

		:imm8, # an immediate byte value. The imm8 symbol is a signed number between -128 and +127 inclusive.
		       # For instructins in which imm8 is combind with a word or doublewod operand, the immediate
		       # value is sign-extended to for a word or doubleword. The upper byte of the word is filled
		       # with the topmost bit of the immediate value

		:m32, # a doubleword operand in memory, usually expressed as a variable or array name, but pointed
		      # to by the DS:(E)SI or ES:(E)DI registers. This nomenclature is ued only with the string
		      # instructions

		:m64, # a memory quadword operand in memory. This nomenclaure is used only with the CMPXCHG8B instruction.

		:m128, # a memory double quadwrd operand in memory.
	]

	attr_reader :instructions

	def initialize (&block)
		@instructions = Hash.new {|hash, key| hash[key] = []}

		instance_eval &block
	end

	def to_hash
		@instructions
	end

	module Piece
		def self.extend (obj)
			obj.extend self

			obj.instance_eval {
				@known   = reverse.drop_while { |x| !x.is_a?(Integer) }.reverse
				@opcodes = self[known.length .. -1]
			}
		end

		attr_reader :known, :opcodes
	end

	Symbols.each {|special|
		define_method special do
			Symbol.new(special)
		end
	}

	def method_missing (id, *args)
		raise ArgumentError, "#{id} isn't supported" if args.empty?

		args.each {|arg|
			if arg.is_a?(Hash)
				arg.each {|key, value|
					Piece.extend(key)
					Piece.extend(value)
				}
			else
				Piece.extend(arg)
			end
		}

		@instructions[id.to_sym.upcase].push(*args)
	end
end

end; end; end
