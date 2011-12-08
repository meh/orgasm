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
		@inherits = []
		@supports = []
		@options  = {}

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

	def with (options)
		clone.tap { |d| d.instance_eval {
			@options = options
		} }
	end

	def assemble (instructions, options={})
		if !options[:extensions].nil?
			options[:extensions] = [options[:extensions]].flatten.compact.uniq
		end

		if !options[:extensions].is_a?(Array)
			options[:extensions] = []
		end

		if options[:extensions] && @options[:extensions]
			options[:extensions].unshift(*@options[:extensions])
		end

		options = @options.merge(options)

		unless options[:exceptions] == false
			options.each_key {|name|
				next if %w(extensions).to_syms.member?(name)

				unless options[:exceptions] == false || supports?(name)
					raise ArgumentError, "#{name} is an unsupported option"
				end
			}

			options[:extensions].each {|name|
				unless arch.extensions.all? { |extension| extension.name.to_s.downcase == extension.to_s.downcase && extension.disassembler }
					raise ArgumentError, "#{name} isn't supported by #{arch.name}"
				end
			}
		end

		instructions = [instructions] unless instructions.is_a?(Array)
		encoders     = to_a(options)

		String.new.tap {|result|
			instructions.each {|instruction|
				unless catch :skip do
					encoders.any? {|encoder|
						if tmp = encoder.encode(instruction)
							result << tmp
						end
					}
				end or
					raise NoMethodError, "#{instruction.inspect} couldn't be assembled"
				end
			}
		}
	end; alias do assemble

	def encoder (&block)
		block ? @encoder = Encoder.new(self, &block) : @encoder
	end

	def to_a (options)
		result = []

		result << encoder.for(options)

		(options[:extensions] || []).each {|name|
			arch.extensions.select {|extension|
				extension.name.to_s.downcase == name.to_s.downcase
			}.each {|extension|
				result.push(*extension.assembler.to_a(options))
			}
		}

		@inherits.each {|inerhited|
			result.push(*inherited.to_a(options))
		}

		result.flatten.compact.uniq
	end

	def | (value)
		Pipeline.new(self, value)
	end
end

end

require 'orgasm/assembler/encoder'
require 'orgasm/assembler/pipeline'
