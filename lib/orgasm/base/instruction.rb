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

module Orgasm

class Instruction < Returnable
	attr_reader :name, :parameters

	def initialize (name = nil, *parameters)
		self.name   = name if name
		@parameters = parameters.to_a.flatten.compact

		super()
	end

	def name= (value)
		@name = value.downcase.to_sym
	end

	def == (other)
		name == other.name && parameters == other.parameters
	end; alias === ==

	def inspect
		"#<Instruction(#{"@#{at} " if at}#{name})#{": #{parameters.map(&:inspect).join(', ')}" unless parameters.empty?}>"
	end
end

end
