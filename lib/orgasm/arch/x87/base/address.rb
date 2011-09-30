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

class Address < Orgasm::Address
	attr_accessor :size

	def initialize (value=nil, size=32, options={})
		if value.respond_to? :to_i
			super(value)
		else
			super()
		end

		@size    = size
		@options = options
	end

	def relative?
		!!@options[:relative]
	end

	def offset?
		!!@options[:offset]
	end

	def inspect
		"#<Address: #{'0x%X' % to_i}, #{size} bits>"
	end
end

end; end
