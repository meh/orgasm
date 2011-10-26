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

require 'orgasm/arch/x87/extensions'
require 'orgasm/arch/x87/base'
require 'orgasm/arch/x87/instructions'

Orgasm::Architecture.is 'x87' do
	family '8087' do
		instructions 'orgasm/arch/x87/instructions/8087'
		disassembler 'orgasm/arch/x87/disassembler/16'
	end

	family 'i187' do
		instructions arch[8087].instructions.deep_clone, 'orgasm/arch/x87/instructions/i187'
		disassembler 'orgasm/arch/x87/disassembler/32'
	end

	family 'i287' do
		instructions arch[:i187].instructions.deep_clone, 'orgasm/arch/x87/instructions/i287'
		disassembler 'orgasm/arch/x87/disassembler/32'
	end

	family 'i387' do
		instructions arch[:i287].instructions.deep_clone, 'orgasm/arch/x87/instructions/i387'
		disassembler 'orgasm/arch/x87/disassembler/32'
		disassembler.supports :mode
	end

	family 'i487' do
		instructions arch[:i387].instructions.deep_clone, 'orgasm/arch/x87/instructions/i487'
		disassembler 'orgasm/arch/x87/disassembler/32'
		disassembler.supports :mode
	end

	family 'i587' do
		instructions arch[:i487].instructions.deep_clone, 'orgasm/arch/x87/instructions/i587'
		disassembler 'orgasm/arch/x87/disassembler/32'
		disassembler.supports :mode
	end

	family 'i687' do
		instructions arch[:i587].instructions.deep_clone, 'orgasm/arch/x87/instructions/i687'
		disassembler 'orgasm/arch/x87/disassembler/32'
		disassembler.supports :mode
	end
end
