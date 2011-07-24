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
  attr_reader :disassembler

  def initialize (disassembler, *args, &block)
    @disassembler = disassembler
    @args         = args.flatten(1).compact
    @block        = block
  end

  def method_missing (*args, &block)
    @disassembler.__send__ *args, &block
  end

  def for (io, options)
    decoder = self.clone
    decoder.instance_variable_set :@io, io
    decoder.instance_variable_set :@options, options
    decoder
  end

  def call (what)
    return unless @io

    case what
      when :inherit, :inherited
        @disassembler.inherits.any? {|inherited|
          if tmp = inherited.disassembler.disassemble(io, limit: 1, unknown: false).first
            break tmp
          end
        }

      when :extension, :extensions
        @disassembler.extensions.select {|extension|
          @options[:extensions].member?(extension.name)
        }.any? {|extension|
          if tmp = extension.disassembler.disassemble(io, limit: 1, unknown: false)
            break tmp
          end
        }
    end
  end

  def decode
    return unless @io

    return unless match = @args.find {|arg|
      matches(arg)
    }

    catch(:result) {
      start = @io.tell

      skip(start) if catch(:skip) {
        result(instance_exec @args, match, &@block)
        false
      }
    }
  end

  def matches (what)
    return false unless @io

    return true if what === true

    where, result = @io.tell, if what.is_a?(Regexp)
      !!@io.read.match(what)
    elsif what.is_a?(Array) or what.is_a?(Integer)
      what = [what].flatten.compact.pack('C*')

      @io.read(what.length) == what
    else
      what = what.to_s

      @io.read(what.length) == what
    end

    @io.seek where

    result
  end

  def on (*args, &block)
    return unless @io

    return unless match = args.flatten(1).compact.find {|arg|
      matches(arg)
    }

    result(instance_exec args, match, &block)
  end

  def always (&block)
    result(instance_eval &block)  
  end

  def seek (amount, whence=IO::SEEK_CUR, &block)
    return unless @io

    if block
      where, = @io.tell, @io.seek(amount, whence)

      result(instance_eval &block).tap {
        @io.seek(where)
      }
    else
      @io.seek(amount, whence)
    end
  end

  def read (amount, &block)
    return unless @io and amount.to_i > 0

    data = @io.read(amount)

    if data.nil? or data.length != amount
      raise RuntimeError, "the stream has not enough data, #{amount - (data.length rescue 0)} byte/s missing"
    end

    if block
      result(instance_exec data, &block).tap {
        seek -amount
      }
    else
      data
    end
  end

  def lookahead (amount)
    read(amount) do |data|
      data
    end rescue nil
  end

  def skip (start=nil, &block)
    return disassembler.skip &block if block
      
    if start.nil?
      throw :skip, true
    else
      instance_eval &disassembler.skip if disassembler.skip

      @io.seek(start)
    end
  end

  private
    def result (value)
      if Orgasm.object?(value)
        throw :result, value
      end

      value
    end
end

end; end
