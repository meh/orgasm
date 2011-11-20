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

class Symbol
	class Operator
		def self.all_operators
			@operators ||= {}
		end

		def self.new (first, second)
			all_operators[[first, second]] ||= super(first, second)
		end

		attr_reader :first, :second

		def initialize (first, second)
			@first  = first
			@second = second
		end

		def =~ (value)
			first =~ value || second =~ value
		end

		def method_missing (id, *args, &block)
			return first.__send__(id, *args, &block)  if first.respond_to?(id)
			return second.__send__(id, *args, &block) if second.respond_to?(id)

			super
		end
	end

	class Or < Operator
		def or?; true; end
			
		def to_s
			"#{first}|#{second}"
		end
	end

	class And < Operator
		def and?; true; end

		def to_s
			"#{first}&#{second}"
		end
	end

	class Offset < Operator
		def offset?; true; end

		def to_s
			"#{first}:#{second}"
		end
	end
	
	def self.all_symbols
		@symbols ||= {}
	end

	def self.new (value)
		all_symbols[value] ||= super(value)
	end

	extend Forwardable

	def_delegators :@value, :to_s, :to_sym, :hash

	def initialize (value)
		@value = value.to_sym
	end

	%w(or and offset).each {|name|
		define_method "#{name}?" do
			false
		end
	}

	def +@
		clone.tap {|o|
			o.instance_eval {
				@signed = true
			}
		}
	end

	def -@
		clone.tap {|o|
			o.instance_eval {
				@signed = false
			}
		}
	end

	def signed?
		!!@signed
	end

	def | (value)
		Or.new(self, value)
	end

	def & (value)
		And.new(self, value)
	end

	def ^ (value)
		Offset.new(self, value)
	end

	def == (value)
		to_sym == value.to_sym rescue super
	end; alias eql? ==

	def =~ (value)
		if value.is_a?(Integer)
			bits == value or Instructions.register?(to_s) == value
		else
			to_s.start_with?(value.to_s)
		end
	end

	memoize
	def bits
		{ b: 8, w: 16, d: 32, q: 64, o: 64 }[to_s[-1].to_sym] || to_s[/\d+$/].to_i
	rescue
		nil
	end
end

class ModR
	EffectiveAddress = {
		16 => {
			'000'.bin => [:bx, :si],
			'001'.bin => [:bx, :di],
			'010'.bin => [:bp, :si],
			'011'.bin => [:bp, :di],
			'100'.bin => [:si],
			'101'.bin => [:di],
			'110'.bin => [:bp],
			'111'.bin => [:bx]
		},

		32 => {
			'000'.bin => [:eax],
			'001'.bin => [:ecx],
			'010'.bin => [:edx],
			'011'.bin => [:ebx],
			'100'.bin => [],
			'101'.bin => [:ebp],
			'110'.bin => [:esi],
			'111'.bin => [:edi]
		}
	}

	def initialize (value = 0)
		@value = (value.is_a?(String) ? value.bin : value.to_i)
	end

	def mod
		(to_i & '11000000'.bin) >> 6
	end

	def mod= (value)
		@value &= '00111111'.bin
		@value |= (value.is_a?(String) ? value.bin : value.to_i) << 6
	end

	def reg
		(to_i & '00111000'.bin) >> 3
	end; alias opcode reg

	def reg= (value)
		@value &= '11000111'.bin
		@value |= (value.is_a?(String) ? value.bin : value.to_i) << 3
	end; alias opcode= reg=

	def rm
		(to_i & '00000111'.bin)
	end

	def rm= (value)
		@value &= '11111000'.bin
		@value |= (value.is_a?(String) ? value.bin : value.to_i)
	end

	def register?
		mod == '11'.bin
	end

	def memory?
		!register?
	end

	def sib?
		mod != '11'.bin && rm == '100'.bin
	end

	def displacement_size (bits)
		case bits
		when 16
			if    mod == '00'.bin && rm == '110'.bin then 16.bit
			elsif mod == '01'.bin                    then 8.bit
			elsif mod == '10'.bin                    then 16.bit
			end
		when 32
			if    mod == '00'.bin && rm == '101'.bin then 32.bit
			elsif mod == '01'.bin                    then 8.bit
			elsif mod == '10'.bin                    then 32.bit
			end
		end
	end

	def effective_address (bits, displacement=nil)
		return displacement if bits == 16 && mod == '00'.bin && rm == '110'.bin ||
			                     bits == 32 && mod == '00'.bin && rm == '101'.bin

		EffectiveAddress[bits][rm] + [displacement].compact
	end

	def to_i
		@value
	end

	def inspect
		"#<ModR: Mod=#{'%02b' % mod} Reg/Opcode=#{'%03b' % reg} R/M=#{'%03b' % rm}>"
	end
end

class SIB
	def initialize (value = 0)
		@value = (value.is_a?(String) ? value.bin : value.to_i)
	end

	def scale
		(to_i & '11000000'.bin) >> 6
	end

	def scale= (value)
		@value &= '00111111'.bin
		@value |= (value.is_a?(String) ? value.bin : value.to_i) << 6
	end

	def index
		(to_i & '00111000'.bin) >> 3
	end

	def index= (value)
		@value &= '11000111'.bin
		@value |= (value.is_a?(String) ? value.bin : value.to_i) << 3
	end

	def base
		(to_i & '00000111'.bin)
	end

	def base= (value)
		@value &= '11111000'.bin
		@value |= (value.is_a?(String) ? value.bin : value.to_i)
	end

	def to_i
		@value
	end

	def inspect
		"#<SIB: Scale=#{'%02b' % scale} Index=#{'%03b' % index} Base=#{'%03b' % base}>"
	end
end

class REX
	def initialize (value = 0x40)
		@value = (value.is_a?(String) ? value.bin : value.to_i)

		unless @value >= 0x40 && @value <= 0x4F
			@value = (@value & '00001111'.bin) | '01000000'.bin
		end
	end

	def w?
		(to_i & '00001000'.bin) >> 3 == 1
	end

	def w!
		@value |= '00001000'.bin
	end

	def no_w!
		@value &= '11110111'.bin
	end

	def r?
		(to_i & '00000100'.bin) >> 2 == 1
	end

	def r!
		@value |= '00000100'.bin
	end

	def no_r!
		@value &= '11111011'.bin
	end

	def x?
		(to_i & '00000010'.bin) >> 1 == 1
	end

	def x!
		@value |= '00000010'.bin
	end

	def no_x!
		@value &= '11111101'.bin
	end

	def b?
		(to_i & '00000001'.bin) == 1
	end

	def b!
		@value |= '00000001'.bin
	end

	def no_b!
		@value &= '11111110'.bind
	end

	def to_i
		@value
	end

	def inspect
		"#<REX#{?. if w? or r? or x? or b?}#{?W if w?}#{?R if r?}#{?X if x?}#{?B if b?}>"
	end
end

class Data
	Sizes = { ib: 1, iw: 2, id: 4, io: 8, cb: 1, cw: 2, cd: 4, cp: 6, co: 8, ct: 10 }

	def self.valid? (value)
		Sizes.key?(value.to_sym) && value
	rescue
		false
	end

	attr_reader :type, :size

	def initialize (io, type)
		@type   = type.to_sym.downcase
		@signed = type.signed?
		@size   = Sizes[@type].bytes or raise ArgumentError, "unknown type #{type}"
		@value  = io.read(size.bits).to_bytes(signed: signed?)
	end

	def signed?;    @signed; end
	def unsigned?; !@signed; end

	def to_i
		@value
	end
end

class Prefixes < Array
	Holes = [0xC1]

	Lock   = [0xF0]
	Repeat = [0xF2, 0xF3]

	module Override
		Segment = [0x2E, 0x36, 0x3E, 0x26, 0x64, 0x65]
		
		module Size
			Operand = [0x66]
			Address = [0x67]
		end
	end

	REX = (0x40 .. 0x4F).to_a

	For = {
		16 => [Holes, Lock, Repeat, Override::Segment],
		32 => [Holes, Lock, Repeat, Override::Segment, Override::Size::Operand, Override::Size::Address],
		64 => [Holes, Lock, Repeat, Override::Segment, Override::Size::Operand, Override::Size::Address, REX]
	}

	attr_reader :bits, :options

	def initialize (bits, options={})
		@bits    = bits
		@options = options
	end

	memoize
	def valid? (value)
		return false if bits == 64 && rex?

		For[bits].any? {|check|
			check.member?(value)
		} && value
	end

	def lock? (check = nil)
		if check
			Lock.member?(check)
		else
			any? {|value|
				Lock.member?(value)
			}
		end
	end

	def lock!
		push Lock.first
	end

	def no_lock!
		Lock.each { |n| delete n }
	end

	def repeat? (check = nil)
		if check
			Repeat.member?(check)
		else
			any? {|value|
				Repeat.member?(value)
			}
		end
	end

	def repeat!
		push Repeat.first
	end

	def no_repeat!
		Repeat.each { |n| delete n }
	end

	def size (check = nil)
		(address?(check) || (options[:mode] == :real && !address?(check))) ? 16 : 32
	end

	def operand? (check = nil)
		if check
			Override::Size::Operand.member?(check)
		else
			any? {|value|
				Override::Size::Operand.member?(value)
			}
		end
	end

	def operand!
		push Override::Size::Operand.first
	end

	def no_operand!
		Override::Size::Operand.each { |n| delete n }
	end

	def address? (check = nil)
		if check
			Override::Size::Address.member?(check)
		else
			any? {|value|
				Override::Size::Address.member?(value)
			}
		end
	end

	def address!
		push Override::Size::Address.first
	end

	def no_address!
		Override::Size::Address.each { |n| delete n }
	end

	def size? (check = nil)
		operand?(check) or address?(check)
	end

	def rex? (check = nil)
		if check
			REX.member?(check)
		else
			any? {|value|
				REX.member?(value)
			}
		end
	end

	def rex
		X86::REX.new(reverse.find {|value|
			REX.member?(value)
		})
	end

	def inspect
		"#<Prefixes(#{' address' if address?}#{' operand' if operand?})>"
	end
end

end; end
