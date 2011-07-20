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

require 'orgasm/common'
require 'orgasm/disassembler/decoder'

module Orgasm

class Disassembler
  @@archs = {}

  def self.for (arch, &block)
    if block
      @@archs[arch] = self.new(arch, &block)
    else
      @@archs[arch]
    end
  end

  attr_reader :architecture

  alias arch architecture

  def initialize (architecture, &block)
    @architecture = architecture
    @decoders     = []

    instance_eval(&block)
  end

  def disassemble (io)
    if io.is_a?(String)
      require 'stringio'

      io = StringIO.new(io)
    end

    result = []

    until io.eof?
      where = io.tell

      @decoders.each {|decoder|
        if tmp = Orgasm.object?(decoder.with(io).decode)
          result << tmp
          break
        end
      }

      if where == io.tell
        raise RuntimeError, 'No input was read, something is wrong with the decoders'
      end
    end

    result.flatten.compact
  end

  def on (*args, &block)
    @decoders << Decoder.new(*args, &block)
  end
end

end
