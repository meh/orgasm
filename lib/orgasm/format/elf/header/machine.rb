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

class Machine
	attr_reader :header

	def initialize (header, what)
		@header = header
		@value  = what.is_a?(Symbol) ? what : {
			1 => :m32,
			2 => :sparc,
			3 => :i386,
			4 => :m68k,
			5 => :m88k,
			7 => :i860,
			8 => :mips
		}[what]
	end

	def to_sym
		@value
	end

	def to_s
		{
			m32:   'AT&T WE32100',
			sparc: 'SPARC',
			i386:  'Intel 80386',
			m68k:  'Motorola 68000',
			m88k:  'Motorola 88000',
			i860:  'Intel 80860',
			mips:  'MIPS RS3000'
		}[to_sym]
	end

	def size
		Sizes[@header.identification.class][:half]
	end
end

end; end; end
