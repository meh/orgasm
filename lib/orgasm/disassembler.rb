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

class Disassembler < Piece
	attr_reader :inherits, :supports, :options

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

		self
	end

	def with (options)
		clone.tap { |d| d.instance_eval {
			@options = options
		} }
	end

	def disassemble (io, options={})
		if !options[:extensions].is_a?(Array)
			options[:extensions] = []
		end

		if options[:extensions] && @options[:extensions]
			options[:extensions].unshift(*@options[:extensions])
		end

		options = @options.merge(options)


		unless options[:exceptions] == false
			options.each_key {|name|
				next if %w(extensions exceptions limit unknown inherited).to_syms.member?(name)

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

		io = io.to_opcodes    if io.is_a?(Array)
		io = StringIO.new(io) if io.is_a?(String)

		result   = nil
		junk     = nil
		decoders = to_a(io, options)

		until io.eof?
			start   = io.tell
			decoded = nil

			decoders.any? {|decoder|
				decoded = Orgasm.object?(begin
					decoder.decode
				rescue
					raise unless options[:exceptions] == false
				end) or io.seek(start) and nil
			}

			if decoded
				result ||= []
				result.push(Unknown.new(junk)) and junk = nil if junk
				result.push(decoded) unless decoded.instance_of?(Orgasm::True)
			end

			break if options[:limit] && result && result.length >= options[:limit]

			if start == io.tell
				break if options[:unknown] == false

				(junk ||= '') << io.read(1)
			end
		end

		if junk
			result ||= []
			result.push(Unknown.new(junk))
		end

		result
	end; alias do disassemble

	def decoder (&block)
		block ? @decoder = Decoder.new(self, &block) : @decoder
	end

	def to_a (io, options)
		result = []
		
		result << decoder.for(io, options) if decoder

		(options[:extensions] || []).each {|name|
			arch.extensions.select {|extension|
				extension.name.to_s.downcase == name.to_s.downcase
			}.each {|extension|
				result.push(*extension.disassembler.to_a(io, options))
			}
		}

		@inherits.each {|inerhited|
			result.push(*inherited.to_a(io, options))
		}

		result.flatten.compact.uniq
	end

	def | (value)
		Pipeline.new(self, value)
	end
end

end

require 'orgasm/disassembler/decoder'
require 'orgasm/disassembler/pipeline'
