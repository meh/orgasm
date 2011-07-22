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

class Instruction < Orgasm::Instruction
  module Prefixes
    Lock = [0xF0, 0xF2, 0xF3]

    module Override
      Segment = [0x2E, 0x36, 0x3E, 0x26, 0x64, 0x65]
      
      module Size
        Operand = [0x66]
        Address = [0x67]
      end
    end
  end

  def self.prefix? (value)
    if Prefixes::Lock.member?(value)
      :lock
    elsif Prefixes::Override::Segment.member?(value)
      :segment
    elsif Prefixes::Override::Size::Operand.member?(value)
      :operand
    elsif Prefixes::Override::Size::Address.member?(value)
      :address
    else
      false
    end
  end

  extend Forwardable

  attr_accessor :prefixes
  def_delegator :@parameters, :first, :destination
  def_delegator :@parameters, :last,  :source

  def initialize (name=nil, destination=nil, source=nil, prefixes=[])
    super(name, destination, source)
  end

  def destination= (value)
    parameters[0] = value
  end

  def source= (value)
    parameters[1] = value
  end
end

end; end
