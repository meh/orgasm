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

X86::Instructions[X86::DSL.new(16) {
	inherit 'orgasm/arch/x86/instructions/8086'

	# Check Array Index Against Bounds
	BOUND [r16, m16&16] => [0x62, r]

	# Make Stack Frame for Procedure Parameters
	ENTER [imm16, imm8] => [0xC8, iw, ib]

	# Input from Port to String
	INS [m8, dx]  => [0x6C],
	    [m16, dx] => [0x6D]

	# High Level Procedure Exit
	LEAVE hint(ax)  => [0xC9]

	# Output String to Port
	OUTS [dx, m8]  => [0x6E],
	     [dx, m16] => [0x6F]

	OUTSB hint(al) => [0x6E]

	OUTSW hint(ax) => [0x6F]

	# Pop All General-Purpose Registers
	POPA hint(ax) => [0x61]

	# Push all General-Purpose Registers
	PUSHA hint(ax) => [0x60]

	# Repeat String Operation Prefix
	REP [0xF3, [0x6C]],
	    [0xF3, [0x6D]],
	    [0xF3, [0x6E]],
	    [0xF3, [0x6F]]
}]
