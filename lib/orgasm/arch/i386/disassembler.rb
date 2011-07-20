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

Disassembler.for('i386') {
  reg = registers = Class.new(Hash) {
    def initialize
      merge!(
        32 => {
          EAX: 0x0,
          ECX: 0x1,
          EDX: 0x2,
          EBX: 0x3,
          ESP: 0x4,
          EBP: 0x5,
          ESI: 0x6,
          EDI: 0x7
        },

        16 => {
          AX: 0x0,
          CX: 0x1,
          DX: 0x2,
          BX: 0x3,
          SP: 0x4,
          BP: 0x5,
          SI: 0x6,
          DI: 0x7
        },

        8 => {
          AL: 0x0,
          CL: 0x1,
          DL: 0x2,
          BL: 0x3,
          AH: 0x4,
          CH: 0x5,
          DH: 0x6,
          BH: 0x7
        }
      )
    end

    def source (byte, bits=32)
      self[bits].key((byte & 0x38) >> 3)
    end

    def destination (byte, bits=32)
      self[bits].key(byte & 0x07)
    end; alias dest destination
  }.new

  on ?\x01, ?\x09, ?\x11, ?\x19, ?\x21, ?\x25, ?\x29, ?\x31, ?\x39, ?\x85, ?\x86, ?\x87, ?\x89, ?\xA1, ?\xA3 do
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

    on ?\x01 do
      Instruction.new(:add) {|i|
        seek +1

        read 1 do |data|
          i.parameters << Register.new(reg.source(data.to_byte), 32)
          i.parameters << Register.new(reg.destination(data.to_byte), 32)
        end

        seek increment
      }
    end

    on ?\x09 do
      Instruction.new(:or) {
        seek +1
      }
    end

    on ?\x11 do
      Instruction.new(:adc) {
        seek +1
      }
    end

    on ?\x19 do
      Instruction.new(:sbb) {
        seek +1
      }
    end

    on ?\x21, ?\x25 do
      Instruction.new(:ad) {
        seek +1
      }
    end

    on ?\x29 do
      Instruction.new(:sub) {
        seek +1
      }
    end

    on ?\x31 do
      Instruction.new(:xor) {
        seek +1
      }
    end

    on ?\x19 do
      Instruction.new(:cmp) {
        seek +1
      }
    end

    on ?\x85 do
      Instruction.new(:test) {
        seek +1
      }
    end

    on ?\x86 do
      Instruction.new(:xchg) {
        seek +1

        # 8bit
      }
    end

    on ?\x87 do
      Instruction.new(:xchg) {
        seek +1
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
      # increment = 4
      Instruction.new(:mov) {
        seek +1
      }
    end
  end
}

end
