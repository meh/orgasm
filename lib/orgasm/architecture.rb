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

class Architecture
  @@archs = {}

  class << self
    def for (name, &block)
      (@@archs[name.downcase.to_sym] ||= Architecture.new(name)).do(&block)
    end

    alias is for
    alias in for
  end

  attr_reader :name, :classes

  def initialize (name, &block)
    @name    = name
    @classes = {}

    self.do(&block)
  end

  [:instructions, :disassembler, :assembler, :generator, :style].each {|name|
    define_method name do |path=nil, &block|
      return instance_variable_get("@#{name}") unless path or block

      instance_variable_set("@#{name}", if path
        io = File.open('r', $:.each {|dir|
          dir = File.join(dir, path)

          break dir if File.readable?(dir)
        })

        Orgasm.const_get(name.capitalize).new(self, io)
      else      
        Orgasm.const_get(name.capitalize).new(self, &block)
      end)
    end
  }

  def do (string=nil, &block)
    instance_eval string if string
    instance_eval &block if block
  end

  def method_missing (id, *args, &block)
    return super unless id == id.capitalize

    @classes[id] ||= Class.new(*args, &block)
  end

  def to_s
    @name
  end
end

end
