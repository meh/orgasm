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

module Orgasm; module I386

class Instructions < Hash
  def registers
    [:al,  :cl,  :dl,  :bl,  :ah,  :ch,  :dh,  :bh,
     :ax,  :cx,  :dx,  :bx,  :sp,  :bp,  :si,  :di,
     :eax, :ecx, :edx, :ebx, :esp, :ebp, :esi, :edi]
  end

  def register? (value)
    return unless case value.to_s.downcase
      when /^e[abcd]x$/,
           /^e[bs]p$/,
           /^e[sd]i$/,
           /^[abcd]x$/,
           /^[sb]p$/,
           /^[sd]i$/,
           /^[abcd][lh]$/ then true

      else false
    end

    case value.to_s.downcase
      when /^e/     then 32
      when /[xpi]$/ then 16
      when /[lh]$/  then 8
    end
  end
end

end; end
