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

class DSL
	attr_reader :generators, :result
	attr_writer :before, :instruction

	def initialize (*args, &block)
		if !block
			@block = args.first
		else
			@block = block
			@args  = args
		end
	end

	def execute (*generators)
		@generators = generators.flatten.compact
		@result     = []

		@result.define_singleton_method :symbols do
			@symbols ||= {}
		end

		@result.define_singleton_method :labels do
			@labels ||= {}
		end

		@generators.each { |gen| instance_exec @result, &gen.before }

		if @block.is_a?(Proc)
			instance_exec *@args, &@block
		elsif @block.is_a?(IO)
			instance_eval @block.read, @block.path
		else
			instance_eval @block.to_s
		end

		@result
	end

	def macros (*args, &block)
		@macro_dsl ||= Class.new(BasicObject) {
			def initialize (dsl, *args, &block)
				@dsl = dsl

				instance_exec *args, &block
			end

			def method_missing (id, *args, &block)
				raise ArgumentError, "#{id} is already a method" if @dsl.respond_to?(id)

				@dsl.define_singleton_method id do |*args|
					instance_exec *args, &block
				end
			end
		}
		
		@macro_dsl.new(self, *args, &block)
	end

	def label (name)
		return @result.labels[name] if result.labels[name]

		@result.push(@result.labels[name] = Label.new(name))
	end; alias l label

	def extern (name)
		Extern.new(name)
	end; alias e extern

	def method_missing (id, *args, &block)
		exception = nil

		generators.each {|gen|
			return gen.__send__ id, *args, &block if gen.respond_to?(id)

			begin
				instance_exec(id, *args, &gen.instruction).tap {|i|
					raise NoMethodError if i.nil?

					exception = nil

					@result.push(*[i].flatten.compact)
				}

				break
			rescue NoMethodError => e
				exception = e

				next
			end
		}

		raise exception if exception
	end
end

end; end
