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

module Orgasm; class Generator < Piece

class DSL < BasicObject
	def initialize (&block)
		@block = block
	end

	def execute (generator)
		@generator    = generator
		@instructions = []

		@instructions.tap {
			instance_eval &@block

			remove_instance_variable :@generator
			remove_instance_variable :@instructions
		}
	end

	def method_missing (id, *args, &block)
		if @generator.symbols.member?(id)
			return id
		elsif @generator.respond_to?(id)
			return @generator.__send__ id, *args, &block
		end

		@instructions << @generator.instruction(id, *args)
	end
end

end; end
