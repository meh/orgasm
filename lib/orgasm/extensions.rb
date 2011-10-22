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

require 'forwardable'
require 'stringio'
require 'refining'
require 'memoized'
require 'packable'
require 'retarded'

class String
	def to_bytes (options={})
		unpack(Integer, { endian: :little, signed: false, bytes: bytesize }.merge(options))
	end; alias to_byte to_bytes

	def bin
		to_i(2)
	end
end

class NilClass
	def to_bytes (options={})
		nil
	end; alias to_byte to_bytes
end

class Array
	def to_syms
		map {|x|
			x.to_sym
		}
	end

	def to_opcodes
		map {|b|
			[b.hex].pack(bytes: (b.hex.to_s(16).length / 2.0).ceil)
		}.join ''
	end

	def ignore
		@ignore = true
		self
	end

	def ignore?
		!!@ignore
	end
end

class Integer
	def bits
		self / 8
	end; alias bit bits

	def bytes
		self * 8
	end; alias byte bytes
end

module Kernel
	def suppress_warnings
		exception = nil
		tmp, $VERBOSE = $VERBOSE, nil

		begin
			result = yield

			$VERBOSE = tmp
		rescue Exception => e
			$VERBOSE = tmp

			raise
		end

		result
	end

	def deep_clone
		Marshal.load(Marshal.dump(self))
	end
end

class IO
	def self.get (io)
		if io.is_a?(String)
			File.open(io, ?r)
		else
			io.rewind
			io
		end
	end
end
