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
		32 => %w(eax ecx edx ebx esp ebp esi edi).to_syms
	}

	RegisterCodes = {
		8  => :rb,
		16 => :rw,
		32 => :rd
	}

	def self.register? (value)
		Registers.find {|bits, registers|
			registers.member?(value.to_sym.downcase)
		}.first rescue nil
	end

	def self.register (value, type=32)
		Registers[type][value]
	end

	def self.register_code? (value)
		RegisterCodes.key(value.to_s.to_sym)
	end

	def self.register_code (value, type=32)
		Registers[type][value]
	end
end

end; end
