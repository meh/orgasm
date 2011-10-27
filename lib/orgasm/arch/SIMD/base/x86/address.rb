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

module Orgasm; module SIMD; module X86

class Address < Orgasm::Address
	attr_reader :size, :base, :options

	def initialize (value=nil, size=32, options={})
		self.value = value if value
		self.size  = size  if size

		@options = options

		super()
	end

	def size= (value)
		@size = value.to_i
	end

	def value= (value)
		if value.respond_to? :to_i
			super(value)
		else
			@base = value

			if @base.last.respond_to? :to_i
				super(@base.pop)
			end

			@base.map! {|p|
				X86::Register.new(p)
			}
		end
	end

	alias bits size

	def relative?
		!!@options[:relative]
	end

	def offset?
		!!@options[:offset]
	end

	def base?
		!!@base
	end

	def == (other)
		to_i == other.to_i && relative? == other.relative?
	end

	def === (other)
		self == other && size == other.size
	end

	def inspect
		if relative? || offset?
			"#<Address: #{'%+d' % to_i}, #{size} bits>"
		elsif base?
			"#<Address: [#{base.map(&:name).join '+'}#{'%+d' % to_i if to_i}], #{size} bits>"
		else
			"#<Address: #{'0x%x' % to_i}, #{size} bits>"
		end
	end
end

end; end; end
