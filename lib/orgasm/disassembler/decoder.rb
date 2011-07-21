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

module Orgasm; class Disassembler < Piece

class Decoder
  def initialize (*args, &block)
    @args  = args
    @block = block
  end

  def with (io)
    @io = io
    self
  end

  def decode
    return unless @io

    return unless match = @args.find {|arg|
      matches(arg)
    }

    catch(:result) {
      instance_exec @args, match, &@block
    }
  end

  def matches (what)
    return false unless @io

    where, result = @io.tell, if what.is_a?(Regexp)
      !!@io.read.match(what)
    else
      what = what.to_s
      @io.read(what.length) == what
    end

    @io.seek where

    result
  end

  def on (*args, &block)
    return unless @io

    return unless match = args.find {|arg|
      matches(arg)
    }

    result = instance_exec args, match, &block

    if Orgasm.object?(result)
      throw :result, result
    end

    result
  end

  def seek (amount, whence=IO::SEEK_CUR, &block)
    return unless @io

    if block
      where, = @io.tell, @io.seek(amount, whence)

      result = instance_eval &block

      if Orgasm.object?(result)
        throw :result, result
      end

      @io.seek(where)

      result
    else
      @io.seek(amount, whence)
    end
  end

  def read (amount, &block)
    return unless @io

    if block
      data = @io.read(amount)

      if data.nil? or data.length != amount
        raise RuntimeError, 'The stream has not enough data :('
      end

      result = instance_exec data, &block

      if Orgasm.object?(result)
        throw :result, result
      end

      seek -amount

      result
    else
      @io.read(amount)
    end
  end

  def lookahead (amount)
    read(amount) do |data|
      data
    end rescue nil
  end
end

end; end
