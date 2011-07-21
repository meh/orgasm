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

require 'orgasm/styles/style'

module Orgasm

class Styles < Piece
  def initialize (*)
    @styles = []

    super
  end

  def style (*args, &block)
    @styles << Style.new(*args, &block)
  end

  def use (name)
    @current = @styles.find {|style|
      style.names.member?(name)
    }
  end

  def current
    @current or use(@styles.first.name)
  end

  def extend (*things)
    styles = self

    things.flatten.compact.each {|thing|
      thing.refine_method :to_s do |old, *|
        begin
          styles.apply(self) or old.call or inspect
        rescue
          old.call or inspect
        end
      end
    }
  end

  def apply (thing)
    current.apply(thing)
  end
end

end
