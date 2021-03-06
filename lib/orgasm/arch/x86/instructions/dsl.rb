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

module Orgasm; module X86

class DSL
	Symbols = {
		16 => [
			:al, :cl, :dl, :bl, :ah, :ch, :dh, :bh,
			:ax, :cx, :dx, :bx, :sp, :bp, :si, :di,
			:cs, :ss, :ds, :es, :fs, :gs,

			# ?n # a digit between 0 ad 7 indicate that the ModR/M byte of the instruction
			     # uses only the r/m (register or memory) operand.
			     # The reg field contains the digit that provides an extension to the instruction's
			     # opcode.

			:r, # indicates that the ModR/M byte of the instruction contains both a register operand
			    # and an r/m operand.

			:cb, # 1 byte
			:cw, # 2 bytes

			:ib, # 1 byte
			:iw, # 2 bytes

			:rb, # a register code, from 0 through 7, added to the hexadecimal byte given at the left
			:rw, # of the plus sign to form a single opcode byte.
			:rd,

			:moffs8,  # a simple memory variable (memory offset) of type byte,
			:moffs16, # word, or doubleword used by some variants of the MOV instruction. The actual address is
			          # given by a simple offset relative to the segment base. No ModR/M byte is used in the
			          # instruction. The number shown with moffs indicates its size, which is determined by the
			          # address-size attribute of the instruction.

			:rel8, # a relative address in the range from 128 byes before the end of the instruction to
			       # 127 bytes after the end of the instruction

			:rel16, # a relative address withn the same code segment as the instruction assembled. Applies to
			        # instructions with an operand-size attribute of 16 bits

			:ptr16, # a far pointer, typically in a code segment different from that of the istuction.
			        # The notation of 16:16 indicates that the value of the pointer has two parts. The value
			        # to the left of he colon is a 16-bit selctor or value destined for the code segmet register.
			        # The valueto the right corresponds to the offset within the destination segmet. The ptr16:16
			        # symbol is used when the instruction's operand-size attribute is 16 bits; the ptr16:32 symbol
			        # is used wen the operand-size attribute is 32 bits.

			:r8, # one of the byte gneral-purpose registers:  AL, CL, DL, BL, AH, CH, DH, BH

			:r16, # one of the word general-purpose registers: AX, CX, DX, BX, SP, BP, SI, DI
			
			:imm8, # an immediate byte value. The imm8 symbol is a signed number between -128 and +127 inclusive.
			       # For instructins in which imm8 is combind with a word or doublewod operand, the immediate
			       # value is sign-extended to for a word or doubleword. The upper byte of the word is filled
			       # with the topmost bit of the immediate value
			
			:imm16, # an immediate word value used forinstructions hose operand-size attribute is 16 bits.
			        # This is a number between -32768 and +32767 inclusive.

			:m, # a 16 or 32 bit operand in memory.

			:m8, # a byte operand in memory, usually expressed as a variable or array name, but pointed to by
			     # the S:(E)SI or ES:(E)DI registers. This nomeclature is used only with the string instructions
			     # and the XLAT instruction.

			:m16, # a word operand in memory, usually exressed as a variable or array name, but pointed to by
			      # the DS()SI or ES(E)DI registers. This nomenclature is used only with te string instructions.

			# r8|m8 # a byte operand thtis either the contents of a byte general-purpose register (AL, BL, CL, DL,
			        # AH, BH, CH and DH), or a byte from memory

			# r16|m16 # a word general-purpose register or memoy operand used for instructions whose operan-size attribute
			          # is 16 bits. The word gneral-purpose regsters are: AX, bx, CX, DX, SP, BP, SI and DI.

			:Sreg, :sreg # a segment register
		],

		32 => [
			:eax, :ecx, :edx, :ebx, :esp, :ebp, :esi, :edi,
			:cr0, :cr1, :cr2, :cr3, :cr4, :cr5, :cr6, :cr7,
			:dr0, :dr1, :dr2, :dr3, :dr4, :dr5, :dr6, :dr7,

			:cd, # 4 bytes
			:cp, # 6 bytes
			     # value following the opcode that is used to specify a code offset ad possibly a new
			     # value for the code segment register

			:id, # 4 bytes
			     # immediate operand to the instruction that follows the opcode, ModR/M bytes or
			     # scale-indexing bytes. The opcode determines if the operand is a signed value.

			:moffs32, # a simple memory variable (memory offset) of type byte,
			          # word, or doubleword used by some variants of the MOV instruction. The actual address is
			          # given by a simple offset relative to the segment base. No ModR/M byte is used in the
			          # instruction. The number shown with moffs indicates its size, which is determined by the
			          # address-size attribute of the instruction.

			:rel32, # a relative address withn the same code segment as the instruction assembled. Applies to
			        # instructions with an operand-size attribute of 32 bits

			:r32, # one of the double-word general purpose registers: EAX, ECX, EDX, EBX, ESP, EBP, ESI, EDI

			:cr, # one of the double-word control registers CR0, CR1, CR2, CR3, CR4, CR5, CR6, CR7

			:dr, # one of the double-word control registers DR0, DR1, DR2, DR3, DR4, DR5, DR6, DR7

			:imm32, # an immediate doubleword value used for instructions whose operand-size attribute is 32 bits.
			        # It allows the use of a number between +2147483647 and -2147483648 inclusive.

			:m32, # a doubleword operand in memory, usually expressed as a variable or array name, but pointed
			      # to by the DS:(E)SI or ES:(E)DI registers. This nomenclature is ued only with the string
			      # instructions

			:m64, # a memory quadword operand in memory. This nomenclaure is used only with the CMPXCHG8B instruction.


			# r32|m32 # a doubleword general-purpose register or memory operand used for instructions whose operand-size
			          # attribute is 32 bits. The doubleword general-purpose registers are: EAX, EBX, ECX, EDX, ESP,
			          # EBP ESI and EDI. The contents of memory are found at the address provided by the effective
			          # address computation
		],

		64 => [
			:rax, :rcx, :rdx, :rbx, :rsp, :rbp, :rsi, :rdi,

			:r64,

			:ro,

			:io,

			:moffs64,

			:imm64
		]
	}

	attr_reader :bits, :instructions

	def initialize (bits, &block)
		@bits         = bits
		@instructions = Hash.new { |hash, key| hash[key] = [] }

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

		def hint?;   !!@hint;         end
		def hint!;     @hint = true;  end
		def not_hint!; @hint = false; end

		def no_rex?; !@rex;         end
		def rex!;     @rex = true;  end
		def no_rex!;  @rex = false; end

		def invalid_in_mode? (mode)
			@invalid_in && @invalid_in.member?(mode)
		end

		def invalid_in_mode (mode = nil)
			mode ? (@invalid_in ||= []) << mode : @invalid_in
		end
	end

	def hint (*args)
		Piece.extend(args)
		args.hint!
		args
	end; alias h hint

	def no_rex (*args)
		Piece.extend(args)
		args.no_rex!
		args
	end; alias n no_rex

	Symbols.each {|bit, specials|
		specials.each {|special|
			define_method special do
				raise ArgumentError, "#{special} isn't supported at #{bits} bits." if bits < bit

				Symbol.new(special)
			end
		}
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

	class Invalid < self
		def initialize (mode, dsl, &block)
			@mode         = mode
			@bits         = dsl.bits
			@instructions = dsl.instructions

			instance_eval &block
		end

		def method_missing (id, *args)
			raise ArgumentError, "#{id} isn't supported" if args.empty?

			args.each {|arg|
				@instructions[id.to_sym.upcase].each {|description|
					if description.is_a?(Hash)
						description.each {|key, value|
							value.invalid_in_mode(@mode) if key == arg || value == arg
						}
					else
						description.invalid_in_mode(@mode) if description == arg
					end
				}
			}
		end
	end

	def invalid_in_mode (mode, &block)
		Invalid.new(mode, self, &block)
	end
end

end; end
