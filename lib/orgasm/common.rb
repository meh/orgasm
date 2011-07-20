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

require 'orgasm/common/extensions'

require 'orgasm/common/unknown'
require 'orgasm/common/instruction'
require 'orgasm/common/address'
require 'orgasm/common/register'
require 'orgasm/common/constant'

module Orgasm

def self.object? (value)
  [Unknown, Instruction, Address, Register, Constant].any? {|klass|
    value.is_a?(klass)
  } && value
end

end
