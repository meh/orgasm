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

X87::Instructions[X87::DSL.new {
  # Packed Single-FP Add
  ADDPS [xmm1, xmm2|m128] => [0x0F, 0x58, r]

  # Scalar Single-FP Add
  ADDSS [xmm1, xmm2|m32] => [0xF3, 0x0F, 0x58, r]

  # Bit-wise Logical And ot For Single-FP
  ANDNPS [xmm1, xmm2|m128] => [0x0F, 0x55, r]

  # Bit-wise Logical And For Single FP
  ANDPS [xmm1, xmm2|m128] => [0x0F, 0x54, r]

  CMPPS [xmm1, xmm2|m128, imm8] => [0x0F, 0xC2, r, ib]

  CMPSS [xmm1, xmm2|m32, imm8] => [0xF3, 0x0F, 0xC2, r, ib]
}]
