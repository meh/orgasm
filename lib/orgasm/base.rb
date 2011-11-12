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

class Base
	def initialize
		yield self if block_given?
	end
end

class True < Base
	def self.new
		@instance ||= super
	end
end

def self.object? (value)
	(value && value.is_a?(Base)) ? value : false
end

end

require 'orgasm/base/unknown'
require 'orgasm/base/instruction'
require 'orgasm/base/address'
require 'orgasm/base/register'
require 'orgasm/base/constant'
require 'orgasm/base/label'
require 'orgasm/base/extern'
