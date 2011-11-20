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

	def initialize (disassembler, &block)
		@disassembler = disassembler
		@block        = block
	end

	def method_missing (*args, &block)
		@disassembler.__send__ *args, &block
	end

	def inherited?
		@options[:inherited]
	end

	def for (io, options)
		clone.tap { |d| d.instance_eval {
			@io      = io
			@options = options
		} }
	end

	def decode
		return unless @io

		catch(:result) {
			start = @io.tell

			@io.seek(start) if catch(:skip) {
				result &@block

				false
			}
		}
	end

	def seek (amount, whence=IO::SEEK_CUR)
		return unless @io

		@io.seek(amount, whence)
	end

	def read (amount)
		return unless @io and amount.to_i > 0

		data = @io.read(amount)

		if !data or data.length != amount
			raise NeedMoreData, "the stream has not enough data, #{amount - (data.length rescue 0)} byte/s missing"
		end

		data
	end

	def lookahead (amount)
		data = @io.read(amount)
		@io.seek -data.length rescue nil
		data
	end

	def skip
		throw :skip, true
	end

	def done (value = nil)
		throw :result, value || Orgasm::True.new
	end

	def result (&block)
		value = begin
			instance_eval &block
		rescue LocalJumpError; end or return

		if Orgasm.object?(value)
			throw :result, value
		end
	end
end

end; end
