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

class Offset
  attr_reader :start

  def initialize (start, value)
    @start = start
    @value = value.to_i

    unless @start.is_a?(Address) || @start.is_a?(Register) || @start.is_a?(Constant)
      raise ArgumentError, 'The starting point has to be an Address, Register or Constant object'
    end

    yield self if block_given?
  end

  def to_i
    @value
  end
end

end
