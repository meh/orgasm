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

module Orgasm; class Assembler < Piece

class Encoder
	attr_reader :assembler, :options

	def initialize (assembler, &block)
		@assembler = assembler
		@block     = block
	end

	def method_missing (*args, &block)
		@assembler.__send__ *args, &block
	end

	def for (options)
		clone.tap { |e| e.instance_eval {
			@options = options
		} }
	end

	def encode (instruction)
		catch :result do
			instance_exec instruction, &@block
		end
	end

	def done (value)
		throw :result, value
	end

	def skip
		throw :skip, true
	end
end

end; end
