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

module Orgasm; module X87

class DSL
	Symbols = [
		:ax,

		# ?n # a digit between 0 ad 7 indicate that the ModR/M byte of the instruction
		     # uses only the r/m (register or memory) operand.
		     # The reg field contains the digit that provides an extension to the instruction's
		     # opcode.

		:i, # a number used in floating-point instructions when one of the operands is ST(i) from the FPU
		    # register stack. The number i (which can range from 0 to 7) is added to the hexadecimal
		    # byte given at the left of the plus sign to form a single opcode byte.

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

	attr_reader :instructions

	def initialize (&block)
		@instructions = Hash.new {|hash, key| hash[key] = []}

		instance_eval &block
	end

	def inherit (path = nil)
		@instructions.merge!(if path
			path = $:.each {|dir|
				dir = File.join(dir, "#{path}.rb")

				break dir if File.readable?(dir)
			}.tap {|o|
				raise LoadError, "no such file to load -- #{path}" unless o.is_a?(String)
			}

			eval File.read(path), nil, path, 1
		else
			yield
		end)
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

end; end
