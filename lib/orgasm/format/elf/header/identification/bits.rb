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

module Orgasm; class Format; class ELF; class Header; class Identification

class Bits
  def self.from (io)
    Retarded.new IO.get(io) do |io|
      io.seek 4

      Bits.new({ 1 => 32, 2 => 64 }[io.read(1).to_byte])
    end
  end

  def initialize (value)
    @value = value
  end

  def to_s
    to_i.to_s
  end

  def to_i
    @value
  end
end

end; end; end; end; end
