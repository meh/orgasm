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

module Orgasm; class Styles < Piece

class Style
	attr_reader :names

	def initialize (*names)
		@names = names
		@for   = {}

		yield self
	end

	def for (klass, &block)
		@for[klass] = block
	end

	def apply (thing)
		callback = @for[thing.class] or @for.find {|(what, block)|
			what.ancestors.member?(thing.class)
		}.last

		if callback
			thing.instance_eval &callback
		end
	end

	def name
		names.first
	end

	def to_s
		name
	end
end

end; end
