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
	# Conditional Move
	CMOVA [r16, r16|m16] => [0x0F, 0x47, r],
	      [r32, r32|m32] => [0x0F, 0x47, r]

	CMOVAE [r16, r16|m16] => [0x0F, 0x43, r],
	       [r32, r32|m32] => [0x0F, 0x43, r]

	CMOVB [r16, r16|m16] => [0x0F, 0x42, r],
	      [r32, r32|m32] => [0x0F, 0x42, r]

	CMOVBE [r16, r16|m16] => [0x0F, 0x46, r],
	       [r32, r32|m32] => [0x0F, 0x46, r]

	CMOVC [r16, r16|m16] => [0x0F, 0x42, r],
	      [r32, r32|m32] => [0x0F, 0x42, r]

	CMOVE [r16, r16|m16] => [0x0F, 0x44, r],
	      [r32, r32|m32] => [0x0F, 0x44, r]

	CMOVG [r16, r16|m16] => [0x0F, 0x4F, r],
	      [r32, r32|m32] => [0x0F, 0x4F, r]

	CMOVGE [r16, r16|m16] => [0x0F, 0x4D, r],
	       [r32, r32|m32] => [0x0F, 0x4D, r]

	CMOVL [r16, r16|m16] => [0x0F, 0x4C, r],
	      [r32, r32|m32] => [0x0F, 0x4C, r]

	CMOVLE [r16, r16|m16] => [0x0F, 0x4E, r],
	       [r32, r32|m32] => [0x0F, 0x4E, r]

	CMOVNA [r16, r16|m16] => [0x0F, 0x46, r],
	       [r32, r32|m32] => [0x0F, 0x46, r]

	CMOVNAE [r16, r16|m16] => [0x0F, 0x42, r],
	        [r32, r32|m32] => [0x0F, 0x42, r]

	CMOVNB [r16, r16|m16] => [0x0F, 0x43, r],
	       [r32, r32|m32] => [0x0F, 0x43, r]

	CMOVNBE [r16, r16|m16] => [0x0F, 0x47, r],
	        [r32, r32|m32] => [0x0F, 0x47, r]

	CMOVNC [r16, r16|m16] => [0x0F, 0x43, r],
	       [r32, r32|m32] => [0x0F, 0x43, r]

	CMOVNE [r16, r16|m16] => [0x0F, 0x45, r],
	       [r32, r32|m32] => [0x0F, 0x45, r]

	CMOVNG [r16, r16|m16] => [0x0F, 0x4E, r],
	       [r32, r32|m32] => [0x0F, 0x4E, r]

	CMOVNGE [r16, r16|m16] => [0x0F, 0x4C, r],
	        [r32, r32|m32] => [0x0F, 0x4C, r]

	CMOVNL [r16, r16|m16] => [0x0F, 0x4D, r],
	       [r32, r32|m32] => [0x0F, 0x4D, r]

	CMOVNLE [r16, r16|m16] => [0x0F, 0x4F, r],
	        [r32, r32|m32] => [0x0F, 0x4F, r]

	CMOVNO [r16, r16|m16] => [0x0F, 0x41, r],
	       [r32, r32|m32] => [0x0F, 0x41, r]

	CMOVNP [r16, r16|m16] => [0x0F, 0x4B, r],
	       [r32, r32|m32] => [0x0F, 0x4B, r]

	CMOVNS [r16, r16|m16] => [0x0F, 0x49, r],
	       [r32, r32|m32] => [0x0F, 0x49, r]

	CMOVNZ [r16, r16|m16] => [0x0F, 0x45, r],
	       [r32, r32|m32] => [0x0F, 0x45, r]

	CMOVO [r16, r16|m16] => [0x0F, 0x40, r],
	      [r32, r32|m32] => [0x0F, 0x40, r]

	CMOVP [r16, r16|m16] => [0x0F, 0x4A, r],
	      [r32, r32|m32] => [0x0F, 0x4A, r]

	CMOPE [r16, r16|m16] => [0x0F, 0x4A, r],
	      [r32, r32|m32] => [0x0F, 0x4A, r]

	CMOVPO [r16, r16|m16] => [0x0F, 0x4B, r],
	       [r32, r32|m32] => [0x0F, 0x4B, r]

	CMOVS [r16, r16|m16] => [0x0F, 0x48, r],
	      [r32, r32|m32] => [0x0F, 0x48, r]

	CMOVZ [r16, r16|m16] => [0x0F, 0x44, r],
	      [r32, r32|m32] => [0x0F, 0x44, r]

	# Fast Transition to System Call Entry Point
	SYSENTER [0x0F, 0x34]

	# Fast Transition from System Call Entry Point
	SYSEXIT [0x0F, 0x35]

	# Undefined Instruction
	UD2 [0x0F, 0x0B]
}]
