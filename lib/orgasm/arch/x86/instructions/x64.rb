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

X86::Instructions[X86::DSL.new(64) {
	inherit 'orgasm/arch/x86/instructions/i686'

	invalid_if -> { options[:mode] == :long } do
		AAA [0x37]

		AAD [0xD5, 0x0A],
		    [0xD5, ib]

		PUSH [r32]
	end

	PUSH n(r64) => [0x50, +ro]

	POP n(r64) => [0x58, +ro]

	# Move
	MOV [r64|m64, r64]     => [0x89, r],
	    [r64,     r64|m64] => [0x8B, r],
	    [eax,     moffs64] => [0xA1, cd],
	    [moffs32, eax]     => [0xA3, cd],
	    [r64,     imm64]   => [0xB8, ro, io],
	    [r64|m64, imm32]   => [0xC7, ?0, id]
}]
