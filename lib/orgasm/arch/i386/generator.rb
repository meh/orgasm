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

module Orgasm

Generator.for 'i386' do |generator|
  generator.symbol! do |value|
    case value.to_s.downcase
      when /e[abcd]x/, /e[bs]p/, /e[sd]i/, /[abcd]x/, /[sb]p/, /[sd]i/, /[abcd][lh]/ then true
      else false
    end
  end

  generator.for Instruction do |name, &block|
    Instruction.new(name, &block)
  end

  generator.for Register do |name|
    Register.new(name) {|r|
      r.size = case name.to_s.downcase
        when /^e/i     then 32
        when /[xpi]$/i then 16
        when /[lh]$/i  then 8
      end
    }
  end

  generator.for Address do |data|
    if data.is_a?(Array)
      nil
    else
      Address.new(data)
    end
  end

  generator.for Constant do |data|
    Constant.new(data)
  end
end

end
