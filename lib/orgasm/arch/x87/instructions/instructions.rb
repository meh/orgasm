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

module Orgasm; module X87

class Instructions < Hash
	def self.[] (*args)
		new(*args)
	end

	attr_reader :lookup

	def initialize (hash)
		merge!(hash.respond_to?(:to_hash) ? hash.to_hash : hash)

		@lookup = lookup!

		freeze
	end

	def [] (name)
		super(name.to_sym.upcase)
	end

	module Definition
		def self.extend (obj)
			obj.extend self

			obj.instance_eval {
				@modr = if self[2].is_a?(String)
					self[2].to_i
				elsif self[1].is_a?(String)
					self[1].to_i
				end
			}
		end

		attr_reader :modr

		def modr?
			opcodes.first == :r || modr
		end
	end

	module Parameters
		def self.extend (obj)
			obj.extend self
		end

		def destination; self[0]; end
		def source;      self[1]; end
	end

	def lookup!
		klass  = Struct.new(:name, :definition, :parameters)
		lookup = []

		each {|name, definition|
			definition.each {|definition|
				if definition.is_a?(Hash)
					definition.each {|params, definition|
						if definition.include?(:i)
							definition    = definition.clone
							definition[0] = definition[0] ... (definition[0] + 8)
						end

						Parameters.extend params
						Definition.extend definition

						lookup << klass.new(name, definition, params)
					}
				else
					Definition.extend definition

					lookup << klass.new(name, definition, nil)
				end
			}
		}

		lookup.define_singleton_method :table do @table end
		lookup.instance_variable_set :@table, lookup.map {|i|
			type = i.definition[0].is_a?(Range) ? :splat : :normal

			first  = i.definition[0].is_a?(Range) ? i.definition[0].min : i.definition[0]
			second = i.definition[1].is_a?(Integer) ? i.definition[1] : -1
			modr   = i.definition.modr || -1

			Struct.new(:type, :opcodes, :modr).new(type, [first, second], modr)
		}

		lookup
	end
end

end; end
