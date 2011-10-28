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

	def initialize (value)
		@value = value.to_sym
	end

	%w(or and offset).each {|name|
		define_method "#{name}?" do
			false
		end
	}

	def +@
		@signed = true

		self
	end

	def -@
		@signed = false

		self
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
		if value.is_a?(::Symbol)
			to_sym == value
		else
			super
		end
	end

	def =~ (value)
		if value.is_a?(Integer)
			bits == value or Instructions.register?(to_s) == value
		else
			to_s.start_with?(value.to_s)
		end
	end

	def bits
		{ b: 8, w: 16, d: 32, q: 64 }[to_s[-1].to_sym] || to_s[/\d+$/].to_i
	rescue
		nil
	end

	def to_s
		to_sym.to_s
	end

	def to_sym
		@value
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

class Data
	Sizes = { ib: 1, iw: 2, id: 4, io: 8, cb: 1, cw: 2, cd: 4, cp: 6, co: 8, ct: 10 }

	def self.valid? (value)
		Sizes.key?(value.to_sym) rescue false
	end

	attr_reader :type, :size

	def initialize (io, type)
		@type  = type.to_sym.downcase
		@size  = Sizes[@type].bytes or raise ArgumentError, "unknown type #{type}"
		@value = io.read(size.bits).to_bytes(signed: type.signed?)
	end

	def to_i
		@value
	end
end

class Prefixes < Array
	module Override
		Segment = [0x2E, 0x36, 0x3E, 0x26, 0x64, 0x65]
		
		module Size
			Operand = [0x66]
			Address = [0x67]
		end
	end

	def self.valid? (value)
		[Override::Segment, Override::Size::Operand, Override::Size::Address].any? {|check|
			check.member?(value)
		} && value
	end
	
	attr_reader :options

	def initialize (options={})
		@options = options
	end

	def size
		(address? || (options[:mode] == :real && !address?)) ? 16 : 32
	end

	def operand?
		any? {|value|
			Override::Size::Operand.member?(value)
		}
	end

	def address?
		any? {|value|
			Override::Size::Address.member?(value)
		}
	end

	def size?
		operand? or address?
	end

	def inspect
		"#<Prefixes(#{' address' if address?}#{' operand' if operand?})>"
	end
end

end; end
