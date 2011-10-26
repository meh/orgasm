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

require 'orgasm/arch/x86/extensions'
require 'orgasm/arch/x86/base'
require 'orgasm/arch/x86/instructions'

Orgasm::Architecture.is 'x86' do
	family '8086' do
		instructions 'orgasm/arch/x86/instructions/8086'
		disassembler 'orgasm/arch/x86/disassembler/16'
		generator    'orgasm/arch/x86/generator/16'
		assembler    'orgasm/arch/x86/assembler/16'
	end

	family 'i186' do
		instructions arch[8086].instructions.deep_clone, 'orgasm/arch/x86/instructions/i186'
		disassembler 'orgasm/arch/x86/disassembler/32'
	end

	family 'i286' do
		instructions arch[:i186].instructions.deep_clone, 'orgasm/arch/x86/instructions/i286'
		disassembler 'orgasm/arch/x86/disassembler/32'
	end

	family 'i386' do
		instructions arch[:i286].instructions.deep_clone, 'orgasm/arch/x86/instructions/i386'
		disassembler 'orgasm/arch/x86/disassembler/32'
		disassembler.supports :mode
	end

	family 'i486' do
		instructions arch[:i386].instructions.deep_clone, 'orgasm/arch/x86/instructions/i486'
		disassembler 'orgasm/arch/x86/disassembler/32'
		disassembler.supports :mode
	end

	family 'i586' do
		instructions arch[:i486].instructions.deep_clone, 'orgasm/arch/x86/instructions/i586'
		disassembler 'orgasm/arch/x86/disassembler/32'
		disassembler.supports :mode
	end

	family 'i686' do
		instructions arch[:i586].instructions.deep_clone, 'orgasm/arch/x86/instructions/i686'
		disassembler 'orgasm/arch/x86/disassembler/32'
		disassembler.supports :mode
	end

	styles 'orgasm/arch/x86/styles'
end
