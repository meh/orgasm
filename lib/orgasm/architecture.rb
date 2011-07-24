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

    def [] (name)
      @@archs[name.downcase.to_sym]
    end

    def method_missing (id, *)
      self[id] or super
    end
  end

  attr_reader :name, :families, :extensions

  def initialize (name, &block)
    @name = name

    @families   = []
    @extensions = []

    self.do(&block)
  end

  def do (&block)
    instance_eval &block if block
  end

  def [] (name)
    @families.find {|family|
      name.to_s == family.name
    }
  end

  def instructions (path=nil, &block)
    return @instructions unless path or block

    @instructions = if path
      path = $:.each {|dir|
        dir = File.join(dir, "#{path}.rb")

        break dir if File.readable?(dir)
      }.tap {|o|
        raise LoadError, "no such file to load -- #{path}" unless o.is_a?(String)
      }

      instance_eval File.read(path), path, 1
    else
      instance_eval &block
    end
  end

  [:disassembler, :assembler, :generator, :styles].each {|name|
    define_method name do |path=nil, &block|
      return instance_variable_get("@#{name}") unless path or block

      instance_variable_set("@#{name}", if path
        io = File.open($:.each {|dir|
          dir = File.join(dir, "#{path}.rb")

          break dir if File.readable?(dir)
        }.tap {|o|
          raise LoadError, "no such file to load -- #{path}" unless o.is_a?(String)
        }, ?r)

        Orgasm.const_get(name.capitalize).new(self, io) or super
      else      
        Orgasm.const_get(name.capitalize).new(self, &block) or super
      end)
    end
  }

  def family (name, &block)
    @families << Family.new(self, name, &block)
  end

  def extension (name, &block)
    @extensions << Extension.new(self, name, &block)
  end

  def to_s
    @name
  end
end

end

require 'orgasm/architecture/family'
require 'orgasm/architecture/extension'
