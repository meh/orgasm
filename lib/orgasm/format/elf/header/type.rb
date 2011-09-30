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

module Orgasm; class Format; class ELF

class Type
	def initialize (header, what)
		@header = header
		@value  = what.is_a?(Symbol) ? what : { 1 => :relocatable, 2 => :executable, 3 => :shared, 4 => :core }[what]
	end

	def to_sym
		@value
	end

	def to_s
		{
			relocatable: 'relocatable file',
			executable:  'executable',
			shared:      'shared object',
			core:        'core file'
		}[to_sym]
	end
end

end; end; end
