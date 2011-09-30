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

require 'orgasm/format/elf/sizes'
require 'orgasm/format/elf/header'

module Orgasm; class Format

class ELF
	def self.valid? (io)
		IO.get(io).read(4) == "\x7FELF"
	end

	def self.from (io)
		io = IO.get(io)

		ELF.new(Header.from(io), Sections.from(io))
	end

	attr_reader :header

	def initialize (header, optionals={})
		@header = header

		optionals.each {|name, value|
			instance_variable_set "@#{name}", value
		}
	end

	[:program_table, :sections, :segments, :section_table].each {|name|
		define_method name do
			instance_variable_get "@#{name}"
		end
	}

	memoize
	def header
		Header.new(self)
	end

	def inspect
		"#<ELF #{header.identification.class}-bit #{header.identification.encoding} #{header.type}, #{header.machine}, #{header.version}>"
	end
end

Format.define 'ELF' do
	valid? do |io|
		ELF.valid?(io)
	end

	load do |io|
		ELF.from(io)
	end
end

end; end
