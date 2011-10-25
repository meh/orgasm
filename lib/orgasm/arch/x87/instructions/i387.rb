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
	# Cosine
	FCOS [0xD9, 0xFF]

	# Load FPU Environment
	FLDENV [m14byte|m28byte] => [0xD9, ?4]

	# Partial Remainder
	FPREM1 [0xD9, 0xF5]

	# Sine
	FSIN [0xD9, 0xFE]

	# Sine and Cosine
	FSINCOS [0xD9, 0xFB]

	# Unordered Compare Real
	FUCOM [0xDD, 0xE1],
	      [sti] => [0xDD, 0xE0, i]

	FUCOMP [0xDD, 0xE9],
	       [sti] => [0xDD, 0xE8, i]

	FUCOMPP [0xDA, 0xE9]
}]
