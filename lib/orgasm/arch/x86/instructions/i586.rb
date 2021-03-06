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
	inherit 'orgasm/arch/x86/instructions/i486'

	# Compare and Exchange 8 bytes
	CMPXCHG8B [m64] => [0x0F, 0xC7, ?1, m64]
	# FIXME: add support for this shit in 32 bit disassembler
	
	# CPU Identification
	CPUID [0x0F, 0xA2]

	# Read from Model Specific Register
	RDMSR [0x0F, 0x32]

	# Read Performance-Monitoring Counters
	RDPMC [0x0F, 0x33]

	# Read Time-Stamp Counter
	RDTSC [0x0F, 0x31]

	# Resume from System Management Mode
	RSM [0x0F, 0xAA]

	# Write to Model Specific Register
	WRMSR [0x0F, 0x30]
}]
