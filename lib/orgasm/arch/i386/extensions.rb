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

class ModR
  def initialize (value)
    @value = value.to_i
  end

  def mod
    (to_i & '11000000'.to_i(2)) >> 6
  end

  def reg
    (to_i & '00111000'.to_i(2)) >> 3
  end; alias opcode reg

  def rm
    (to_i & '00000111'.to_i(2))
  end

  def register?
    mod == '11'.to_i(2)
  end

  def memory?
    !register?
  end

  def to_i
    @value
  end

  def inspect
    "#<ModR/M: Mod=#{'%02b' % mod} Reg/Opcode=#{'%03b' % reg} R/M=#{'%03b' % rm}>"
  end
end

class SIB
  def initialize (value)
    @value = value.to_i
  end

  def scale
    (to_i & '11000000'.to_i(2)) >> 6
  end

  def index
    (to_i & '00111000'.to_i(2)) >> 3
  end

  def base
    (to_i & '00000111'.to_i(2))
  end

  def to_i
    @value
  end

  def inspect
    "#<SIB: Scale=#{'%02b' % scale} Index=#{'%03b' % index} Base=#{'%03b' % base}>"
  end
end

class Data
  Sizes = { ib: 1, iw: 2, id: 4, cb: 1, cw: 2, cd: 4, cp: 6 }

  def self.valid? (value)
    Sizes.key?(value.to_sym) rescue false
  end

  attr_reader :type, :size

  def initialize (io, type)
    @type  = type.to_s.downcase.to_sym
    @size  = Sizes[@type] or raise ArgumentError, "unknown type #{type}"
    @value = io.read(size).to_bytes
  end

  def to_i
    @value
  end
end

end; end
