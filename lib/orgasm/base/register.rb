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

class Register < Base
	attr_reader :name, :size

	def initialize (name=nil, size=nil)
		self.name = name if name
		self.size = size if size

		super()
	end

	def name= (value)
		@name = value.downcase.to_sym
	end

	def size= (value)
		@size = value.to_i
	end

	alias bits size

	def =~ (sym)
		name == sym.downcase
	end

	def == (other)
		name == other.name && (size.nil? || other.size.nil? || size == other.size)
	end

	def === (other)
		name == other.name && size == other.size
	end

	def inspect
		"#<Register: #{@name}#{", #{@size} bits" if @size}>"
	end
end

end
