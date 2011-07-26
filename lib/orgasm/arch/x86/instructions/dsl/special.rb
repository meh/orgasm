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

module Orgasm; module X86; class DSL

class Special
  class Operator
    attr_reader :first, :second

    def initialize (first, second)
      @first  = first
      @second = second
    end

    def is? (value)
      first.is?(value) || (second.is_a?(Symbol) && second.is?(value))
    end
  end

  class Or < Operator
    def to_s
      "#{first}|#{second}"
    end
  end

  class And < Operator
    def to_s
      "#{first}&#{second}"
    end
  end

  class Offset < Operator
    def to_s
      "#{first}:#{second}"
    end
  end

  def initialize (value)
    @value = value.to_sym
  end

  def +@
    @signed = true

    self
  end

  def -@
    @signed = false

    self
  end

  def signed?
    !!@signed
  end

  def | (value)
    Or.new(self, value)
  end

  def & (value)
    And.new(self, value)
  end

  def ^ (value)
    Offset.new(self, value)
  end

  def is? (value)
    if value.is_a?(Integer)
      bits == value or Instructions.register?(to_s) == value
    else
      to_s.start_with?(value.to_s)
    end
  end

  def bits
    to_s[/\d+$/].to_i
  end

  suppress_warnings {
    Symbol.instance_methods.each {|name|
      undef_method name rescue nil
    }
  }

  def method_missing (*args, &block)
    @value.__send__ *args, &block
  end
end

end; end; end
