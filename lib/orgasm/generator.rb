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

require 'orgasm/base'

require 'orgasm/generator/dsl'

module Orgasm

class Generator
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

  def initialize (architecture)
    @for = {}

    yield self
  end

  def style (name=nil)
    if name.nil?
      (@style || Style.current.name).downcase
    else
      @style = name
      self
    end
  end

  def generate (&block)
    DSL.new(&block).execute(self)
  end

  def for (klass, &block)
    if block
      @for[klass] = block
    else
      @for[klass]
    end
  end

  def symbol! (&block)
    @symbol = block
  end

  def symbol? (value)
    @symbol ? @symbol.call(value) : false
  end
end

end
