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

class Piece
	attr_reader :arch

	def initialize (arch, io=nil, &block)
		@arch = arch

		instance_eval io.read, io.path, 1 if io
		instance_eval &block              if block
	end

	def self.inherited (subclass)
		subclass.class_eval {
			define_method subclass.name[/([^:]+)$/].downcase do
				self
			end
		}
	end

	def respond_to? (*args)
		@arch.respond_to?(*args) || super
	end

	def method_missing (id, *args, &block)
		return @arch.__send__ id, *args, &block if @arch.respond_to? id
		super
	end
end

end
