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

require 'orgasm/extensions'
require 'orgasm/exceptions'

module Orgasm

class Format
	@@formats = {}

	def self.define (name, &block)
		@@formats[name] = Format.new(name, &block)
	end

	def self.load (path)
		name, format = @@formats.find {|name, format|
			format.valid?(File.open(path, 'r'))
		}
		
		raise ArgumentError, "#{path} is not in the known file formats" unless format

		format.load(File.open(path, 'r'))
	end

	attr_reader :name

	def initialize (name, &block)
		@name = name

		instance_eval &block
	end

	[:valid?, :load].each {|name|
		define_method name do |*args, &block|
			name = name.to_s.gsub('?', '')

			if block
				instance_variable_set "@#{name}", block
			else
				instance_variable_get("@#{name}").call(*args)
			end
		end
	}
end

end

require 'orgasm/format/elf'
require 'orgasm/format/pe'
