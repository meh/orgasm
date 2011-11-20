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

class Constant < Base
	attr_accessor :value, :size

	def initialize (value = nil, size = nil, signed = false)
		@value  = value.to_i if value
		@size   = size.to_i  if size
		@signed = signed

		super()
	end

	def signed?;   @signed;  end
	def unsigned?; !@signed; end

	def signed!;   @signed = true;  end
	def unsigned!; @signed = false; end

	alias bits size

	def == (other)
		value == other.value && (size.nil? || other.size.nil? || size == other.size)
	end

	def === (other)
		value == other.value && size == other.size
	end

	def to_i
		@value
	end

	def inspect
		if @value.nil?
			'#<Constant: NULL>'
		else
			"#<Constant: #{to_i}#{", #{size} bits" if size}>"
		end
	end
end

end
