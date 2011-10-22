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

class Assembler < Piece
	def initialize (*)
		@matchers = []
		@inherits = []
		@supports = []

		super
	end

	def supports (name)
		@supports << name
		@supports.uniq!
		@supports
	end

	def supports? (name)
		@supports.member?(name)
	end

	def inherit (*args)
		@inherits << args

		@inherits.flatten!
		@inherits.compact!

		@inherits
	end

	def assemble (instructions, options={})
		options = {
			extensions: []
		}.merge(options)

		options.each_key {|name|
			next if %w(extensions).to_syms.member?(name)

			unless supports?(name)
				raise ArgumentError, "#{name} is an unsupported option"
			end
		}

		options[:extensions].clone.each {|name|
			unless arch.extensions.all? { |extension| extension.name == extension && extension.assembler }
				raise ArgumentError, "#{name} isn't supported by #{arch.name}"
			end
		}

		result = ''

		instructions.each {|instruction|
			original = result.length

			unless catch :skip do
				([self] + @inherits).each {|assembler|
					assembler.to_a.each {|matcher|
						if matcher.match.(instruction) && (tmp = instance_exec(instruction, &matcher.block)).is_a?(String)
							result << tmp

							break
						end
					}
				}
				
				nil
			end or original != result.length
				raise NoMethodError, "#{instruction.inspect} couldn't be assembled"
			end
		}

		result
	end; alias do assemble

	def instruction (&block)
		on -> i { i.is_a?(Instruction) }, &block
	end

	def on (match, &block)
		@matchers << Struct.new(:match, :block).new(match, block)
	end

	def skip
		throw :skip, true
	end

	def result? (&block)
		catch :result, &block
	end

	def result! (what)
		throw :result, what
	end

	def to_a
		@matchers
	end

	def | (value)
		Pipeline.new(self, value)
	end
end

end

require 'orgasm/assembler/pipeline'
