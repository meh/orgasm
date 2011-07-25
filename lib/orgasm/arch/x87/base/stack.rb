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

module Orgasm; module X87

class Stack < Orgasm::Register
  attr_reader :index

  def initialize (index=nil)
    self.index = index if index
  end

  def index= (value)
    value = 0 if [:ST0, :ST].member?(value.to_sym.upcase) rescue false

    unless (0 .. 7) === value.to_i
      raise ArgumentError, "#{value} isn't a valid x87 stack index"
    end

    @index = value
    @name  = "ST(#{@index})"
  end
end

end; end
