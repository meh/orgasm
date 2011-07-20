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

Style.define 'Intel' do |style|
  style.for Register do
    name.to_s.downcase
  end

  style.for Address do
    offset? ? "[#{start}#{'%+d' % to_i}]" : "0x#{to_i.to_s(16)}"
  end

  style.for Constant do
    to_i.to_s
  end

  style.for Instruction do
    if parameters.length == 1
      "#{name.to_s.downcase} #{parameters.first}"
    else
      "#{name.to_s.downcase} #{parameters.last}, #{parameters.first}"
    end
  end

  style.for Unknown do
    "???(#{to_i})"
  end
end

end
