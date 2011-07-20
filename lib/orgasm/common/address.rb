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

class Address
  attr_reader :start

  def initialize (value, offset=nil)
    if offset
      @start = value
      @value = offset.to_i
    else
      @value = value.to_i
    end

    yield self if block_given?
  end

  def offset?
    !!start
  end

  def to_i
    @value
  end

  def to_s
    offset? ? "[#{start}+#{to_i}]" : "0x%x" % to_i
  end
end

end
