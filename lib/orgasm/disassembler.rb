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

require 'orgasm/disassembler/decoder'

module Orgasm

class Disassembler < Piece
  attr_reader :inherits

  def initialize (*)
    @inherits = []
    @decoders = []

    super
  end

  def inherit (*args)
    @inherits << args

    @inherits.flatten!
    @inherits.compact!

    self
  end

  def disassemble (io, options={})
    options = {
      extensions: []
    }.merge(options)

    if io.is_a?(String)
      require 'stringio'

      io = StringIO.new(io)
    end

    options[:extensions].each {|name|
      unless arch.extensions.any? { |extension| extension.name == extension && extension.disassembler }
        raise ArgumentError, "#{name} isn't supported by #{arch.name}"
      end
    }

    result = []
    junk   = nil

    until io.eof?
      where = io.tell

      added = @decoders.any? {|decoder|
        if tmp = Orgasm.object?(decoder.for(io, options).decode)
          instance_eval &@after if @after
          
          result << unknown(junk) and junk = nil if junk
          result << tmp
        end
      }

      if !added && !@inherits.empty?
        @inherits.any? {|inherited|
          io.seek where

          if tmp = inherited.disassembler.disassemble(io, limit: 1, unknown: false, inherited: true).first
            result << tmp
          end
        }
      end

      break if options[:limit] && result.flatten.compact.length >= options[:limit]

      if where == io.tell
        break if options[:unknown] == false
          
        (junk ||= '') << io.read(1)
      end
    end

    result << unknown(junk) if junk

    result.flatten.compact
  end; alias do disassemble

  def on (*args, &block)
    @decoders << Decoder.new(self, *args, &block)
  end

  def always (&block)
    @decoders << Decoder.new(self, true, &block)
  end

  def unknown (data=nil, &block)
    if block
      @unknown = block
    elsif data
      if @unknown
        instance_exec data, &@unknown
      else
        instance_exec data do |data|
          Unknown.new(data)
        end
      end
    end
  end

  def skip (&block)
    @skip ||= block
  end

  def after (&block)
    @after ||= block
  end

end

end
