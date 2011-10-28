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

X86::Instructions[X86::DSL.new(32) {
	# Adjust RPL Field of Segment Selector
	ARPL [r16|m16, r16] => [0x63, r]

	# Load Access Rights Byte
	LAR [r16, r16|m16] => [0x0F, 0x02, r],
	    [r32, r32|m32] => [0x0F, 0x02, r]

	# Load Global Descriptor Table Register
	LGDT [m16&32] => [0x0F, 0x01, ?2]

	# Load Interrupt Descriptor Table Register
	LIDT [m16&32] => [0x0F, 0x01, ?3]

	# Load Local Descriptor Table Register
	LDDT [r16|m16] => [0x0F, 0x00, ?2]

	# Load Machine Status Word
	LMSW [r16|m16] => [0x0F, 0x01, ?6]

	# Load Segment Limit
	LSL [r16, r16|m16] => [0x0F, 0x03, r],
	    [r32, r32|m32] => [0x0F, 0x03, r]

	# Load Task Register
	LTR [r16|m16] => [0x0F, 0x00, ?3]

	# Store Global/Interrupt Descriptor Table Register
	SGDT [m] => [0x0F, 0x01, ?0]

	SIDT [m] => [0x0F, 0x01, ?1]

	# Store Local Descriptor Table Register
	SLDT [r16|m16] => [0x0F, 0x00, ?0],
	     [r32|m32] => [0x0F, 0x00, ?0]

	SMSW [r16|m16] => [0x0F, 0x01, ?4],
	     [r32|m16] => [0x0F, 0x01, ?4]

	# Store Task Register
	STR [r16|m16] => [0x0F, 0x00, ?1]

	# Verify a Segment for Reading or Writing
	VERR [r16|m16] => [0x0F, 0x00, ?4]

	VERW [r16|m16] => [0x0F, 0x00, ?5]
}]
