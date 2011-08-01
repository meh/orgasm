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

require 'orgasm/format/elf/header/identification'
require 'orgasm/format/elf/header/type'
require 'orgasm/format/elf/header/machine'
require 'orgasm/format/elf/header/version'

module Orgasm; class Format; class ELF

class Header
  def self.from (io)
    Retarded.new IO.get(io) do |io|
      Header.new(Identification.from(io), Type.from(io), Machine.from(io), Version.from(io))
    end
  end

  attr_reader :identification, :type, :machine, :version

  def initialize (identification, type, machine, version)
    @identification = identification
    @type           = type
    @machine        = machine
    @version        = version
  end
end

end; end; end
