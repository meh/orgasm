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

X86::Instructions::Registers.each {|bits, regs|
	if bits <= 16
		regs.each {|reg|
			define_singleton_method do
				reg
			end
		}
	else
		regs.each {|reg|
			define_singleton_method reg do
				raise NoMethodError, "#{reg} register not supported on 16 bit"
			end
		}
	end
}

instruction do |name, destination = nil, source = nil, source2 = nil|
	raise NoMethodError, "#{name} instruction not found" unless instructions.has_key?(name.upcase)

	data = { destination: destination, source: source, source2: source2 }
	
	data.each {|type, obj|
		if obj.is_a?(Symbol)
			data[type] = X86::Register.new(obj)
		end
	}

	X86::Instruction.new(name, data[:destination], data[:source], data[:source2])
end
