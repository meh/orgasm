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

class Generator < Piece
	def initialize (*)
		@methods = {}

		super
	end

	def define_dsl_method (*names, &block)
		names.each { |name| @methods[name] = block }

		@dsl = nil
	end

	def generate (*args, &block)
		@dsl ||= Class.new(DSL).tap {|klass|
			@methods.each { |name, block| klass.class_eval { define_method name, &block } }
		}

		if !block
			@dsl.new(args.first)
		else
			@dsl.new(*args, &block)
		end.execute(*to_a)
	end; alias do generate

	def instruction (*args, &block)
		if block
			@instruction = block
		else
			@instruction.(*args) if @instruction
		end
	end

	def to_a
		[self]
	end

	def | (value)
		Pipeline.new(self, value)
	end
end

end

require 'orgasm/generator/dsl'
require 'orgasm/generator/pipeline'
