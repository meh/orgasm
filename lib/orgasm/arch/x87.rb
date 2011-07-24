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

require 'orgasm/arch/x87/base'
require 'orgasm/arch/x87/instructions'

Orgasm::Architecture.is 'x87' do
  family '8087' do
    instructions 'orgasm/arch/x87/instructions/8087'

    disassembler 'orgasm/arch/x87/disassembler'
  end

=begin
  family 'i187' do
    instructions 'orgasm/arch/x87/instructions/i187'

    disassembler 'orgasm/arch/x87/disassembler/32'
    disassembler.inherit(arch[8087].disassembler)
  end

  family 'i287' do
    instructions 'orgasm/arch/x87/instructions/i287'

    disassembler 'orgasm/arch/x87/disassembler/32'
    disassembler.inherit(arch[:i187].disassembler)
  end

  family 'i387' do
    instructions 'orgasm/arch/x87/instructions/i387'

    disassembler 'orgasm/arch/x87/disassembler/32'
    disassembler.inherit(arch[:i287].disassembler)
  end

  family 'i487' do
    instructions 'orgasm/arch/x87/instructions/i487'

    disassembler 'orgasm/arch/x87/disassembler/32'
    disassembler.inherit(arch[:i387].disassembler)
  end

  styles 'orgasm/arch/x87/styles'
=end
end
