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

class Instruction < Orgasm::Instruction
	extend Forwardable

	def_delegator :@parameters, :first, :destination

	def initialize (name=nil, destination=nil, *sources)
		super(name, destination, *sources)
	end

	def destination= (value)
		parameters[0] = value
	end

	def sources
		parameters[1 .. -1]
	end

	def sources= (*values)
		parameters.slice! 1 .. -1
		parameters.insert(-1, *values.flatten.compact)
	end
end

end; end
