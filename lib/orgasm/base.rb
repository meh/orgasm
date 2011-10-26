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

require 'orgasm/extensions'

module Orgasm

def self.object? (value)
	value.is_a?(Base) ? value : false
end

class True; end

class Base
	def initialize
		yield self if block_given?
	end

	def to_s
		begin
			raise LoadError unless respond_to? :arch

			Architecture[arch].style.apply(self)
		rescue LoadError
			super
		end
	end
end

end

require 'orgasm/base/unknown'
require 'orgasm/base/instruction'
require 'orgasm/base/address'
require 'orgasm/base/register'
require 'orgasm/base/constant'
require 'orgasm/base/label'
require 'orgasm/base/extern'
