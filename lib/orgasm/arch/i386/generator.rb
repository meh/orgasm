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

instructions.registers.each {|register|
  define_singleton_method register do
    register
  end
}

generator.for I386::Instruction do |name, &block|
  I386::Instruction.new(name, &block)
end

generator.for I386::Register do |name|
  I386::Register.new(name)
end

generator.for I386::Address do |data|
  if data.is_a?(Array)
    Address.new(data)
  else
    Address.new(data)
  end
end

generator.for I386::Immediate do |data|
  I386::Immediate.new(data, 32)
end
