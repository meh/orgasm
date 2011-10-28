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
	# Byte Swap
	BSWAP [r32] => [0x0F, 0xC8, rd]

	# Compare and Exchange
	CMPXCHG [r8|m8,   r8]  => [0x0F, 0xB0, r],
	        [r16|m16, r16] => [0x0F, 0xB1, r],
	        [r32|m32, r32] => [0x0F, 0xB1, r]

	# Invalidate Internal Caches
	INVD [0x0F, 0x08]

	# Invalidate TLB Entry
	INVLPG [m16] => [0x0F, 0x01, ?7],
	       [m32] => [0x0F, 0x01, ?7]

	# Write Back and Invalidate Cache
	WBINVD [0x0F, 0x09]

	# Exchange and Add
	XADD [r8|m8,   r8]  => [0x0F, 0xC0, r],
	     [r16|m16, r16] => [0x0F, 0xC1, r],
	     [r32|m32, r32] => [0x0F, 0xC1, r]

	# Exchange Register/Memory with Register
	XCHG [r32|m32, r32]     => [0x87, r],
	     [r32,     r32|m32] => [0x87, r]
}]
