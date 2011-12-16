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

define_dsl_method :data do |*args, &block|
	@data_dsl ||= Class.new(BasicObject) {
		def initialize (dsl, *args, &block)
			@dsl = dsl
			@dsl.result.define_singleton_method :data do
				@data ||= {}
			end unless @dsl.result.respond_to? :data

			instance_exec *args, &block
		end

		def find_size (what)
			return what if what.is_a?(::Integer)

			case what
			when :byte         then 1.byte
			when :short, :word then 2.bytes
			end
		end

		def method_missing (id, size)
			raise ArgumentError, "#{id} has already been defined" if @dsl.result.symbols[id]

			@dsl.result.symbols[id] = @dsl.result.data[id] = ::Orgasm::X86::Address.new(0, find_size(size))
		end
	}
	
	@data_dsl.new(self, *args, &block)
end

define_dsl_method :memory, :m do |value, size = nil|
  if value.is_a?(Integer)
		X86::Address.new(value, size.bytes || 16)
	else
		result.data[value]
	end
end

X86::Instructions::Registers.each {|bits, regs|
	next unless bits.is_a?(Integer)

	if bits <= 16
		regs.each {|reg|
			define_dsl_method reg do
				X86::Register.new(obj)
			end
		}
	else
		regs.each {|reg|
			define_dsl_method reg do
				raise NoMethodError, "#{reg} register not supported on 16 bit"
			end
		}
	end
}

before do
	result.define_singleton_method :data do
		@data ||= {}
	end
end

instruction do |name, destination = nil, source = nil, source2 = nil|
	raise NoMethodError, "#{name} instruction not found" unless instructions[name]

	data = { destination: destination, source: source, source2: source2 }
	
	data.dup.each {|type, obj|
		if obj.is_a?(::Symbol)
			data[type] = result.data[obj] || result.labels[obj] || Extern.new(obj)
		end
	}

	X86::Instruction.new(name, data[:destination], data[:source], data[:source2])
end
