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

class Instructions < Hash
	Registers = {
		int:   %w(mm0  mm1  mm2  mm3  mm4  mm5  mm6  mm7).to_syms,
		float: %w(xmm0 xmm1 xmm2 xmm3 xmm4 xmm5 xmm6 xmm7).to_syms
	}

	def self.register? (value)
		Registers.find {|type, registers|
			registers.member?(value.to_sym.downcase)
		}.first rescue nil
	end

	def self.register (value, type)
		Registers[type][value]
	end

	def [] (name)
		super(name.to_sym.upcase)
	end

	def merge! (other)
		other.each {|name, value|
			if has_key?(name)
				self[name].push(*value)
			else
				self[name] = value
			end
		}
	end
end

end; end; end
