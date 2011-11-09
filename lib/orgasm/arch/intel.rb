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

require 'orgasm'
require 'orgasm/arch/x86'
require 'orgasm/arch/x87'
require 'orgasm/arch/SIMD'

module Orgasm::Architecture::Intel
	@bits = {
		32 => Class.new {
			def self.disassembler
				@disassembler ||=
					Orgasm::Architecture.x86.i686.disassembler |
					Orgasm::Architecture.x87.i687.disassembler |
					Orgasm::Architecture.SIMD.x86.disassembler
			end
		},

		64 => Class.new {
			def self.disassembler
				@disassembler ||=
					Orgasm::Architecture.x86.x64.disassembler |
					Orgasm::Architecture.x87.i687.disassembler |
					Orgasm::Architecture.SIMD.x86.disassembler
			end
		}
	}

	def self.[] (bits)
		@bits[bits]
	end

	def self.method_missing (id, *args, &block)
		self[32].__send__ id, *args, &block
	end
end
