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

class Style
  @@styles  = {}
  @@current = nil

  def self.define (name, &block)
    @@styles[name.downcase.to_sym] = Style.new(name, &block)
  end

  def self.get (name)
    @@styles[name.downcase.to_sym]
  end

  def self.current (name=nil)
    if name
      @@current = get(name)
    else
      @@current
    end || @@styles.first.last
  end

  def self.apply (thing, name = current.name)
    if !get(name)
      raise LoadError, 'No loaded styles'
    else
      get(name).apply(thing)
    end
  end

  attr_reader :name

  def initialize (name)
    @name = name
    @for  = {}

    yield self
  end

  def for (klass, &block)
    @for[klass] = block
  end

  def apply (thing)
    thing.instance_eval &@for[thing.class]
  end

  def to_s
    name
  end
end

end

require 'orgasm/style/intel'
require 'orgasm/style/at&t'
