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

on -> i { i.parameters.length == 0 } do |i|
	next unless opcodes = instructions[i.name]

	result? do
		opcodes.each {|opcodes|
			result! opcodes.map(&:chr).join if opcodes.is_a?(Array)

			opcodes.each {|description, opcodes|
				result! opcodes.map(&:chr).join if description.hint?
			}
		}
	end
end

instruction do |i|
	next unless opcodes = instructions[i.name]

	result? do
		opcodes.each {|opcodes|
			next unless opcodes.is_a?(Hash)

			opcodes.each {|description, opcodes|
				next unless !description.hint? && description.length == i.parameters.length

				bytecode = opcodes.reverse.drop_while {|x|
					!x.is_a?(Integer)
				}.reverse.map(&:chr).join

				destination, source, source2 = description

				next if i.destination.is_a?(X86::Register) &&
					destination !~ :r && i.destination !~ destination

				next if i.destination.is_a?(X86::Address) &&
					destination !~ :m && destinatination !~ :rel && destination !~ :moffs

				if !source

				end
			}
		}
	end
end

label do |l|
	skip
end
