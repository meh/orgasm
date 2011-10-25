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

class Instructions < Hash
	Registers = [:xmm0, :xmm1, :xmm2, :xmm3, :xmm4, :xmm5, :xmm6, :xmm7]

	def self.register? (value)
		Registers.member?((value.to_sym.downcase rescue nil))
	end

	def self.register (value)
		Registers[value]
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

end; end