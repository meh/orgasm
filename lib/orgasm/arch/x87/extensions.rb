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

require 'orgasm/arch/x86/extensions'

module Orgasm; module X87

class Symbol
	def initialize (value)
		@value = value.to_sym
	end

	def == (value)
		if value.is_a?(::Symbol)
			to_sym == value
		else
			super
		end
	end

	def =~ (value)
		if value.is_a?(Integer)
			bits == value
		else
			to_s.start_with?(value.to_s)
		end
	end

	def bits
		to_s[/\d+/].to_i
	rescue
		nil
	end

	def real?
		to_s.end_with? 'real'
	end

	def integer?
		to_s.end_with? 'int'
	end

	def byte?
		to_s.end_with? 'byte'
	end

	def decimal?
		to_s.end_with? 'dec'
	end

	def bcd?
		to_s.end_with? 'bcd'
	end

	def to_s
		to_sym.to_s
	end

	def to_sym
		@value
	end
end

end; end
