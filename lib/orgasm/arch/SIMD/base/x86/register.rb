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

class Register < Orgasm::Register
	attr_reader :type

	def initialize (name=nil)
		super(name, SIMD::X86::Instructions.register?(name) == :int ? 64 : 128)

		self.type = SIMD::X86::Instructions.register?(name)
	end

	def type= (value)
		@type = value.to_sym.downcase
	end

	def name= (value)
		value = value.to_s.downcase.to_sym

		unless SIMD::X86::Instructions.register?(value)
			raise ArgumentError, "#{value} isn't a valid SIMD register"
		end

		@name = value
	end
end

end; end; end
