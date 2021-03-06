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

module Orgasm; module X86

class Instruction < Orgasm::Instruction
	def initialize (name=nil, destination=nil, source=nil, source2=nil)
		super(name, destination, source, source2)
	end

	def lock?;    @lock;         end
	def lock!;    @lock = true;  end
	def no_lock!; @lock = false; end

	def repeat?;    @repeat;         end
	def repeat!;    @repeat = true;  end
	def no_repeat!; @repeat = false; end

	%w(destination source source2).each_with_index {|name, index|
		define_method name do
			parameters[index]
		end

		define_method "#{name}=" do |value|
			parameters[index] = value
		end
	}

	def inspect
		"#<Instruction(#{"@#{at} " if at}#{'lock ' if lock?}#{'rep ' if repeat?}#{name})#{": #{parameters.map(&:inspect).join(', ')}" unless parameters.empty?}>"
	end
end

end; end
