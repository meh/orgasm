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
	Class.new(BasicObject) {
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
			@dsl.result.data[id] = ::Orgasm::X86::Address.new(0, find_size(size))
		end
	}.new(self, *args, &block)
end

define_dsl_method :macros do |*args, &block|
	Class.new(BasicObject) {
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
	}.new(self, *args, &block)
end

define_dsl_method :memory, :m do |value, size = nil|
  if value.is_a?(Integer)
		X86::Address.new(value, size.bytes || 16)
	else
		result.data[value]
	end
end

define_dsl_method :label, :l do |name|
	result.define_singleton_method :labels do
		@labels ||= {}
	end unless result.respond_to? :labels

	return result.labels[name] if result.labels[name]

	result.push(result.labels[name] = Label.new(name))
end

define_dsl_method :extern, :e do |name|
	Extern.new(name)
end

X86::Instructions::Registers.each {|bits, regs|
	if bits <= 16
		regs.each {|reg|
			define_dsl_method reg do
				reg
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

instruction do |name, destination = nil, source = nil, source2 = nil|
	raise NoMethodError, "#{name} instruction not found" unless instructions[name]

	data = { destination: destination, source: source, source2: source2 }
	
	data.each {|type, obj|
		if obj.is_a?(::Symbol)
			data[type] = X86::Register.new(obj)
		end
	}

	X86::Instruction.new(name, data[:destination], data[:source], data[:source2])
end
