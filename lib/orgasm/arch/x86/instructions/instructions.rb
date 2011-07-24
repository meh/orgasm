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

module Orgasm; module X86

class Instructions < Hash
  def self.registers
    [:al,  :cl,  :dl,  :bl,  :ah,  :ch,  :dh,  :bh,
     :ax,  :cx,  :dx,  :bx,  :sp,  :bp,  :si,  :di,
     :eax, :ecx, :edx, :ebx, :esp, :ebp, :esi, :edi]
  end

  def self.register? (value)
    return unless registers.member?((value.to_sym.downcase rescue nil))

    case value.to_s.downcase
      when /^e/     then 32
      when /[xpi]$/ then 16
      when /[lh]$/  then 8
    end
  end

  def self.register (value, type=32)
    Hash[
      8  => %w(al  cl  dl  bl  ah  ch  dh  bh).to_syms,
      16 => %w(ax  cx  dx  bx  sp  bp  si  di).to_syms,
      32 => %w(eax ecx edx ebx esp ebp esi edi).to_syms
    ][type][value]
  end
end

end; end
