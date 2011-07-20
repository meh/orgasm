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

module Orgasm

Style.define 'AT&T' do |style|
  style.for Register do
    "%#{name.to_s.downcase}"
  end

  style.for Address do
    offset? ? "#{to_i}(#{start})" : "0x#{to_i.to_s(16)}"
  end

  style.for Constant do
    "$#{to_i.to_s}"
  end

  style.for Instruction do
    sizes = { b: 8, w: 16, l: 32 }

    "#{name.to_s.downcase}#{sizes.key parameters.first.size} #{parameters.join(', ')}"
  end

  style.for Unknown do
    "???(#{to_i})"
  end
end

end
