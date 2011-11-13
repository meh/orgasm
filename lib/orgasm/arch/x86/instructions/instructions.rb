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

class Instructions < Hash
	Registers = {
		8  => %w(al  cl  dl  bl  ah  ch  dh  bh).to_syms,
		16 => %w(ax  cx  dx  bx  sp  bp  si  di).to_syms,
		32 => %w(eax ecx edx ebx esp ebp esi edi).to_syms,
		64 => %w(rax rcx rdx rbx rsp rbp rsi rdi).to_syms,

		extended: {
			8  => %w(r8l r9l r10l r11l r12l r13l r14l r15l).to_syms,
			16 => %w(r8w r9w r10w r11w r12w r13w r14w r15w).to_syms,
			32 => %w(r8d r9d r10d r11d r12d r13d r14d r15d).to_syms,
			64 => %w(r8  r9  r10  r11  r12  r13  r14  r15 ).to_syms
		}
	}

	SegmentRegisters = %w(es cs ss ds fs gs).to_syms

	RegisterCodes = {
		1 => :rb,
		2 => :rw,
		4 => :rd,
		8 => :ro
	}

	singleton_memoize
	def self.bits (value)
		register?(value) || register?(value, true)
	end

	singleton_memoize
	def self.register? (value, extended = false)
		(extended ? Registers[:extended] : Registers).find {|bits, registers|
			registers.member?(value.to_sym.downcase)
		}.first rescue nil
	end

	singleton_memoize
	def self.register (value, type, extended = false)
		(extended ? Registers[:extended] : Registers)[type][value]
	end

	def self.segment_register (value)
		SegmentRegisters[value]
	end

	singleton_memoize
	def self.register_code? (value)
		RegisterCodes.key(value.to_sym) * 8
	rescue
		nil
	end

	def self.[] (*args)
		new(*args)
	end

	attr_reader :lookup

	def initialize (hash)
		merge!(hash.respond_to?(:to_hash) ? hash.to_hash : hash)

		@lookup = lookup!

		freeze
	end

	def [] (name)
		super(name.to_sym.upcase)
	end

	module Parameters
		def destination; self[0]; end
		def source;      self[1]; end
		def source2;     self[2]; end
	end

	def lookup!
		klass  = Struct.new(:name, :description, :parameters)
		lookup = []

		each {|name, description|
			description.each {|description|
				if description.is_a?(Hash)
					description.each {|params, definition|
						params.extend Parameters

						if X86::Instructions.register_code?(definition.last)
							definition    = definition.clone
							definition[0] = definition[0] ... (definition[0] + 8)
						end

						lookup << klass.new(name, definition, params)
					}
				else
					lookup << klass.new(name, description, nil)
				end
			}
		}

		lookup
	end
end

end; end
