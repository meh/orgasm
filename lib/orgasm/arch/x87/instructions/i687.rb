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

X87::Instructions[X87::DSL.new {
	inherit 'orgasm/arch/x87/instructions/i587'

	# Floating-Point Conditional Move
	FCMOVB [st0, sti] => [0xDA, 0xC0, i]

	FCMOVE [st0, sti] => [0xDA, 0xC8, i]

	FCMOVBE [st0, sti] => [0xDA, 0xD0, i]

	FCMOVU [st0, sti] => [0xDA, 0xD8, i]

	FCMOVNB [st0, sti] => [0xDB, 0xC0, i]

	FCMOVNE [st0, sti] => [0xDB, 0xC8, i]

	FCMOVNBE [st0, sti] => [0xDB, 0xD0, i]

	FCMOVNU [st0, sti] => [0xDB, 0xD8, i]

	# Compare Real and Set EFLAGS
	FCOMI [st0, sti] => [0xDB, 0xF0, i]

	FCOMIP [st0, sti] => [0xDF, 0xF0, i]

	FUCOMI [st0, sti] => [0xDB, 0xE8, i]

	FUCOMIP [st0, sti] => [0xDF, 0xE8, i]
}]
