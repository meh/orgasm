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

require 'orgasm/arch/i386/instructions'

module Orgasm

Disassembler.for('i386') {
  reg = Class.new(Hash) {
    def initialize
      merge!(
        32 => Hash[%w(EAX ECX EDX EBX ESP EBP ESI EDI).to_syms.each_with_index.to_a],
        16 => Hash[%w(AX CX DX BX SP BP SI DI).to_syms.each_with_index.to_a],
        8  => Hash[%w(AL CL DL BL AH CH DH BH).to_syms.each_with_index.to_a]
      )
    end

    def source (byte, bits=32)
      self[bits].key((byte & 0x38) >> 3)
    end

    def destination (byte, bits=32)
      self[bits].key(byte & 0x07)
    end; alias dest destination
  }.new
}

end

=begin
  on ?\x01, ?\x09, ?\x11, ?\x19, ?\x21, ?\x25, ?\x29, ?\x31, ?\x39, ?\x85, ?\x87, ?\x86, ?\x89, ?\xA1, ?\xA3 do |whole, which|
    increment = 1

    seek 1 do
      read 1 do |data|
        increment += 1 if data.to_byte & 0x07 == reg[32][:ESP]
        increment += 1 if (data.to_byte & 0xC0) >> 6 == 0x01

        if (data.to_byte & 0xC0) >> 6 == 0x10
          Unknown.new(1)
        end
      end
    end

    if instruction = %w(add or adc sbb and and sub xor cmp test xchg)[whole.index(which)]
      Instruction.new(instruction) {|i|
        seek +1

        read 1 do |data|
          i.parameters << Register.new(reg.source(data.to_byte), 32)
          i.parameters << Register.new(reg.destination(data.to_byte), 32)
        end
        
        seek increment
      }
    else
      on ?\x86 do
        Instruction.new(:xchg) {|i|
          seek +1

          read 1 do |data|
            i.parameters << Register.new(reg.source(data.to_byte, 8), 8)
            i.parameters << Register.new(reg.destination(data.to_byte, 8), 8)
          end

          seek increment
        }
      end

      on ?\x89 do
        Instruction.new(:mov) {
          seek +1

          read 1 do |data|
            increment = 5 if data.to_byte & 0x07 == 0x05 && data.to_byte < 0x40
          end
        }
      end

      on ?\xA1, ?\xA3 do
        increment = 4

        Instruction.new(:mov) {
          seek +1
        }
      end
    end
  end
}
=end
