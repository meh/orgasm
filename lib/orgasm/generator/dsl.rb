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

module Orgasm; class Generator

class DSL < BasicObject
  def initialize (&block)
    @block = block
  end

  def execute (generator)
    @generator    = generator
    @instructions = []

    instance_eval &@block

    @instructions
  end

  def method_missing (id, *args, &block)
    if @generator.respond_to? id
      return @generator.__send__ id, *args, &block
    end

    @instructions << if @generator.respond_to? :callback
      @generator.callback id, *args, &block
    else
      @generator.for(::Orgasm::Instruction).call(id) {|i|
        args.reverse.each {|arg|
          i.parameters << case arg
            when ::Symbol  then @generator.for(::Orgasm::Register).call(arg)
            when ::Array   then @generator.for(::Orgasm::Address).call(arg)
            when ::Integer then
              if arg.frozen? then @generator.for(::Orgasm::Constant).call(arg)
              else                @generator.for(::Orgasm::Address).call(arg)
              end
          end
        }
      }
    end
  end
end

end; end
