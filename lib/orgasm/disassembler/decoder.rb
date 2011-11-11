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

module Orgasm; class Disassembler < Piece

class Decoder
	attr_reader :disassembler, :options

	def initialize (disassembler, *args, &block)
		@disassembler = disassembler
		@args         = args
		@data         = args.pop if args.last.is_a?(Hash)
		@block        = block
	end

	def method_missing (*args, &block)
		@disassembler.__send__ *args, &block
	end

	def inherited?
		@options[:inherited]
	end

	def for (io, options)
		@io      = io
		@options = options

		if block_given?
			yield self
		else
			return self
		end

		@io      = nil
		@options = nil
	end

	def call (what)
		return unless @io

		case what
			when :inherit, :inherited
				@disassembler.inherits.any? {|inherited|
					if tmp = inherited.disassembler.disassemble(io, limit: 1, unknown: false, inherited: true).first
						break tmp
					end
				}

			when :extension, :extensions
				@disassembler.extensions.select {|extension|
					@options[:extensions].member?(extension.name)
				}.any? {|extension|
					if tmp = extension.disassembler.disassemble(io, limit: 1, unknown: false)
						break tmp
					end
				}
		end
	end

	def decode
		return unless @io

		return unless match = match(*@args)

		catch(:result) {
			start = @io.tell

			skip(start) if catch(:skip) {
				result { instance_exec @args, match, @data, &@block }

				false
			}
		}
	end

	def match (*args)
		args.find { |arg| matches(arg) }
	end

	def matches (what)
		return false unless @io && what

		return true if what == true

		where, result = @io.tell, if what.is_a?(Array)
			@io.read(what.length) == what.pack('C*')
		elsif what.is_a?(Integer)
			@io.read(1) == what.chr
		elsif what.is_a?(Regexp)
			!!@io.read.match(what)
		else
			@io.read(what.length) == what.to_s
		end

		@io.seek where

		result
	end

	def on (*args, &block)
		return unless @io

		data = args.pop if args.last.is_a?(Hash)

		return unless match = match(*args)

		result { instance_exec args, match, data, &block }
	end

	def always (&block)
		result { instance_eval &block }
	end

	def seek (amount, whence=IO::SEEK_CUR, &block)
		return unless @io

		if block
			where, = @io.tell, @io.seek(amount, whence)

			result { instance_eval &block }.tap { @io.seek(where) }
		else
			@io.seek(amount, whence)
		end
	end

	def read (amount, &block)
		return unless @io and amount.to_i > 0

		data = @io.read(amount)

		if data.nil? or data.length != amount
			raise NeedMoreData, "the stream has not enough data, #{amount - (data.length rescue 0)} byte/s missing"
		end

		if block
			result { instance_exec data, &block }.tap { seek -amount }
		else
			data
		end
	end

	def lookahead (amount)
		read(amount) do |data|
			data
		end rescue nil
	end

	def skip (start=nil, &block)
		return disassembler.skip &block if block
			
		if start.nil?
			throw :skip, true
		else
			instance_eval &disassembler.skip if disassembler.skip

			@io.seek(start)
		end
	end

	def done
		throw :result, Orgasm::True.new
	end

	def after (&block)
		return disassembler.after &block
	end

	private

	def result
		value = begin; yield; rescue LocalJumpError; end or return

		if Orgasm.object?(value)
			throw :result, value
		end

		value
	end
end

end; end
