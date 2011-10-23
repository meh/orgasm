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
	def initialize (*args, &block)
		@block = block
		@args  = args
	end

	def execute (*generators)
		@generators   = generators.flatten.compact
		@instructions = []

		instance_exec *@args, &@block

		@instructions
	end

	def method_missing (id, *args, &block)
		exception = nil

		@generators.each {|gen|
			return gen.__send__ id, *args, &block if gen.respond_to?(id)

			return @instructions.push(*gen.__generator_send__(id, *args)) if gen.generator_method?(id)

			begin
				gen.instruction(id, *args).tap {|i|
					raise ::NoMethodError if i.nil?

					@instructions.push(*[i].flatten.compact)
					exception = nil
				}

				break
			rescue ::NoMethodError => e
				exception = e

				next
			end
		}

		::Kernel::raise exception if exception
	end
end

end; end
