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

module Orgasm; module X86; class DSL

class Special
	class Operator
		attr_reader :first, :second

		def initialize (first, second)
			@first  = first
			@second = second
		end

		def =~ (value)
			first =~ value || second =~ value
		end

		def method_missing (id, *args, &block)
			return first.__send__(id, *args, &block)  if first.respond_to?(id)
			return second.__send__(id, *args, &block) if second.respond_to?(id)

			super
		end
	end

	class Or < Operator
		def or?; true; end
			
		def to_s
			"#{first}|#{second}"
		end
	end

	class And < Operator
		def and?; true; end

		def to_s
			"#{first}&#{second}"
		end
	end

	class Offset < Operator
		def offset?; true; end

		def to_s
			"#{first}:#{second}"
		end
	end

	def initialize (value)
		@value = value.to_sym
	end

	%w(or and offset).each {|name|
		define_method "#{name}?" do
			false
		end
	}

	def +@
		@signed = true

		self
	end

	def -@
		@signed = false

		self
	end

	def signed?
		!!@signed
	end

	def | (value)
		Or.new(self, value)
	end

	def & (value)
		And.new(self, value)
	end

	def ^ (value)
		Offset.new(self, value)
	end

	def == (value)
		if value.is_a?(Symbol)
			to_sym == value
		else
			super
		end
	end

	def =~ (value)
		if value.is_a?(Integer)
			bits == value or Instructions.register?(to_s) == value
		else
			to_s.start_with?(value.to_s)
		end
	end

	def bits
		{ b: 8, w: 16, d: 32, q: 64 }[to_s[-1].to_sym] || to_s[/\d+$/].to_i
	rescue
		nil
	end

	def to_s
		to_sym.to_s
	end

	def to_sym
		@value
	end
end

end; end; end
