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
		}
	}

	def initialize (value)
		@value = value.to_i
	end

	def mod
		(to_i & '11000000'.bin) >> 6
	end

	def reg
		(to_i & '00111000'.bin) >> 3
	end; alias opcode reg

	def rm
		(to_i & '00000111'.bin)
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

	def displacement_options (bits)
		{ signed: displacement_size(bits) == 8.bit }
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
		"#<M: Mod=#{'%02b' % mod} Reg/Opcode=#{'%03b' % reg} R/M=#{'%03b' % rm}>"
	end
end

class SIB
	def initialize (value)
		@value = value.to_i
	end

	def scale
		(to_i & '11000000'.bin) >> 6
	end

	def index
		(to_i & '00111000'.bin) >> 3
	end

	def base
		(to_i & '00000111'.bin)
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
	Lock = [0xF0, 0xF2, 0xF3]

	module Override
		Segment = [0x2E, 0x36, 0x3E, 0x26, 0x64, 0x65]
		
		module Size
			Operand = [0x66]
			Address = [0x67]
		end
	end

	def self.valid? (value)
		[Lock, Override::Segment, Override::Size::Operand, Override::Size::Address].any? {|check|
			check.member?(value)
		} && value
	end
	
	attr_reader :options

	def initialize (options={})
		@options = options
	end

	def size
		prefixes.address? || (options[:mode] == :real && !prefixes.address?) ? 16 : 32
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
