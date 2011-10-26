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

class Extern < Base
	attr_reader :name

	def initialize (name=nil)
		self.name = name if name

		super()
	end

	def name= (value)
		@name = value.to_sym
	end

	def == (other)
		to_sym == other.to_sym
	end; alias === ==

	def to_s
		to_sym.to_s
	end

	def to_sym
		@name
	end

	def inspect
		"#<Extern: #{name}>"
	end
end

end
