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

  # Packed Single-FP Compare
  CMPPS [xmm1, xmm2|m128, imm8] => [0x0F, 0xC2, r, ib]

  # Scalar Singl-FP Compare
  CMPSS [xmm1, xmm2|m32, imm8] => [0xF3, 0x0F, 0xC2, r, ib]

  # Scalar Ordere Single-FP Compare and Set EFLAGS
  COMISS [xmm1, xmm2|m32] => [0x0F, 0x2F, r]

  # Packed Signed INT32 to Packed Single-FP Conversion
  # CVTPI2PS [xmm, mm/m64] => [0x0F, 0x2A, r]
  # FIXME: this needs MMX™ registers, investigate further

  # Pakcked Single-FP to Packed INT32 Conversion
  # CVTPS2PI [mm, xmm|m64] => [0x0F, 0x2D, r]
  # FIXME: this needs MMX™ registers, investigate further

  # Scalar Signed INT32 to Single-FP Conversion
  CVTSI2SS [xmm, r32|m32] => [0xF3, 0x0F, 0x2A, r]

  # Scalar Single-FP to Signed INT32 Conversion
  CVTSS2SI [r32, xmm|m32] => [0xF3, 0x0F, 0x2D, r]

  # Packed Single-FP o Packed INT32 Conversion (Truncate)
  # CVTTPS2PI [mm, xmm|m64] => [0x0F, 0x2C, r]
  # FIXME: this needs MMX™ registers, investigate further

  # Scalar Single-FP to Signed INT32 Conversion (Truncate)
  CVTTSS2SI [r32, xmm|m32] => [0xF3, 0x0F, 0x2C, r]

  # Packed Signle-FP Divide
  DIVPS [xmm1, xmm2|m128] => [0x0F, 0x5E, r]

  # Scalar Single-FP Divide
  DIVSS [xmm1, xmm2|m32] => [0xF3, 0x0F, 0x5E, r]


}]
