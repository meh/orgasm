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

require 'orgasm/arch/x86'

require 'orgasm/arch/SIMD/extensions'
require 'orgasm/arch/SIMD/base'
require 'orgasm/arch/SIMD/instructions'

Orgasm::Architecture.is 'SIMD' do
	family 'x86' do
		disassembler 'orgasm/disassembler/dummy'

		extension 'MMX' do
			instructions 'orgasm/arch/SIMD/instructions/x86/mmx'
			disassembler 'orgasm/arch/SIMD/disassembler/x86'
		end
	end
end
