#! /usr/bin/env ruby
require 'rubygems'
require 'orgasm'
require 'orgasm/arch/x86'

describe 'Orgasm::Architecture(x86, 8086)' do
	describe 'disassembler' do
		let :disasm do
			Orgasm::Architecture.x86[8086].disassembler
		end

		describe 'AAA (ASCII Adjust After Addition)' do
			it 'disassembles AAA' do
				disasm.do(%w(37)).tap {|i|
					i.length.should == 1 && i.first.should == Orgasm::X86::Instruction.new(:AAA)
				}
			end
		end

		describe 'AAD (ASCII Adjust AX Before Division)' do
			it 'disassembles AAD' do
				disasm.do(%w(d5 0a)).tap {|i|
					i.length.should == 1 && i.first.should == Orgasm::X86::Instruction.new(:AAD)
				}
			end

			it 'disassembles AAD imm8' do
				disasm.do(%w(d5 2a)).tap {|i|
					i.length.should == 1 && i.first.should == Orgasm::X86::Instruction.new(:AAD,
						Orgasm::X86::Immediate.new(42, 1))
				}
			end
		end

		describe 'AAM (ASCII Adjust AX After Multiply)' do
			it 'disassembles AAM' do
				disasm.do(%w(d4 0a)).tap {|i|
					i.length.should == 1 && i.first.should == Orgasm::X86::Instruction.new(:AAM)
				}
			end

			it 'disassembles AAM imm8' do
				disasm.do(%w(d4 17)).tap {|i|
					i.length.should == 1 && i.first.should == Orgasm::X86::Instruction.new(:AAM,
						Orgasm::X86::Immediate.new(23, 1))
				}
			end
		end

		describe 'AAS (ASCII Adjust AL After Substraction)' do
			it 'disassembles AAS' do
				disasm.do(%w(3f)).tap {|i|
					i.length.should == 1 && i.first.should == Orgasm::X86::Instruction.new(:AAS)
				}
			end

		end

		describe 'ADC (Add with Carry)' do
			it 'disassembles ADC al, imm8' do
				disasm.do(%w(14 2a)).tap {|i|
					i.length.should == 1 && i.first.should == Orgasm::X86::Instruction.new(:ADC,
						Orgasm::X86::Register.new(:al), Orgasm::X86::Immediate.new(42, 1))
				}
			end

			it 'disassembles ADC ax, imm16' do
				disasm.do(%w(15 62 02)).tap {|i|
					i.length.should == 1 && i.first.should == Orgasm::X86::Instruction.new(:ADC,
						Orgasm::X86::Register.new(:ax), Orgasm::X86::Immediate.new(610, 2))
				}
			end

			it 'disassembles ADC r8, imm8' do
				disasm.do(%w(80 d6 17)).tap {|i|
					i.length.should == 1 && i.first.should == Orgasm::X86::Instruction.new(:ADC,
						Orgasm::X86::Register.new(:dh), Orgasm::X86::Immediate.new(23, 1))
				}
			end

			it 'disassembles ADC r16, imm16' do
				disasm.do(%w(81 d3 39 05)).tap {|i|
					i.length.should == 1 && i.first.should == Orgasm::X86::Instruction.new(:ADC,
						Orgasm::X86::Register.new(:bx), Orgasm::X86::Immediate.new(1337, 2))
				}
			end

			it 'disassembles ADC r16, imm8' do
				disasm.do(%w(83 d1 2a)).tap {|i|
					i.length.should == 1 && i.first.should == Orgasm::X86::Instruction.new(:ADC,
						Orgasm::X86::Register.new(:cx), Orgasm::X86::Immediate.new(42, 1))
				}
			end

			it 'disassembles ADC r8, r8' do
				disasm.do(%w(10 d9)).tap {|i|
					i.length.should == 1 && i.first.should == Orgasm::X86::Instruction.new(:ADC,
						Orgasm::X86::Register.new(:cl), Orgasm::X86::Register.new(:bl))
				}
			end

			it 'disassembles ADC m8, r8' do
				disasm.do(%w(10 06 00 20)).tap {|i|
					i.length.should == 1 && i.first.should == Orgasm::X86::Instruction.new(:ADC,
						Orgasm::X86::Address.new(0x2000, 8), Orgasm::X86::Register.new(:al))
				}
			end

			it 'disassembles ADC r16, r16' do
				disasm.do(%w(11 d9)).tap {|i|
					i.length.should == 1 && i.first.should == Orgasm::X86::Instruction.new(:ADC,
						Orgasm::X86::Register.new(:cx), Orgasm::X86::Register.new(:bx))
				}
			end

			it 'disassembles ADC m16, r16' do
				disasm.do(%w(11 16 00 20)).tap {|i|
					i.length.should == 1 && i.first.should == Orgasm::X86::Instruction.new(:ADC,
						Orgasm::X86::Address.new(0x2000, 16), Orgasm::X86::Register.new(:dx))
				}
			end

			it 'disassembles ADC r8, m8' do
				disasm.do(%w(12 0e 00 20)).tap {|i|
					i.length.should == 1 && i.first.should == Orgasm::X86::Instruction.new(:ADC,
						Orgasm::X86::Register.new(:cl), Orgasm::X86::Address.new(0x2000, 16))
				}
			end

			it 'disassembles ADC r16, m16' do
				disasm.do(%w(13 16 00 20)).tap {|i|
					i.length.should == 1 && i.first.should == Orgasm::X86::Instruction.new(:ADC,
						Orgasm::X86::Register.new(:dx), Orgasm::X86::Address.new(0x2000, 16))
				}
			end
		end

		describe 'ADD (Add)' do
			it 'disassembles ADD al, imm8' do
				disasm.do(%w(04 2a)).tap {|i|
					i.length.should == 1 && i.first.should == Orgasm::X86::Instruction.new(:ADD,
						Orgasm::X86::Register.new(:al), Orgasm::X86::Immediate.new(42, 1))
				}
			end

			it 'disassembles ADD ax, imm16' do
				disasm.do(%w(05 62 02)).tap {|i|
					i.length.should == 1 && i.first.should == Orgasm::X86::Instruction.new(:ADD,
						Orgasm::X86::Register.new(:ax), Orgasm::X86::Immediate.new(610, 2))
				}
			end

			it 'disassembles ADD r8, imm8' do
				disasm.do(%w(80 c7 2a)).tap {|i|
					i.length.should == 1 && i.first.should == Orgasm::X86::Instruction.new(:ADD,
						Orgasm::X86::Register.new(:bh), Orgasm::X86::Immediate.new(42, 1))
				}
			end

			it 'disassembles ADD r16, imm16' do
				disasm.do(%w(81 c6 13 09)).tap {|i|
					i.length.should == 1 && i.first.should == Orgasm::X86::Instruction.new(:ADD,
						Orgasm::X86::Register.new(:si), Orgasm::X86::Immediate.new(2323, 2))
				}
			end

			it 'disassembles ADD r16, imm8' do
				disasm.do(%w(83 c5 2a)).tap {|i|
					i.length.should == 1 && i.first.should == Orgasm::X86::Instruction.new(:ADD,
						Orgasm::X86::Register.new(:bp), Orgasm::X86::Immediate.new(42, 1))
				}
			end

			it 'disassembles ADD r8, r8' do
				disasm.do(%w(00 d9)).tap {|i|
					i.length.should == 1 && i.first.should == Orgasm::X86::Instruction.new(:ADD,
						Orgasm::X86::Register.new(:cl), Orgasm::X86::Register.new(:bl))
				}
			end

			it 'disassembles ADD m8, r8' do
				disasm.do(%w(00 06 00 20)).tap {|i|
					i.length.should == 1 && i.first.should == Orgasm::X86::Instruction.new(:ADD,
						Orgasm::X86::Address.new(0x2000, 8), Orgasm::X86::Register.new(:al))
				}
			end

			it 'disassembles ADD r16, r16' do
				disasm.do(%w(01 d9)).tap {|i|
					i.length.should == 1 && i.first.should == Orgasm::X86::Instruction.new(:ADD,
						Orgasm::X86::Register.new(:cx), Orgasm::X86::Register.new(:bx))
				}
			end

			it 'disassembles ADD m16, r16' do
				disasm.do(%w(01 16 00 20)).tap {|i|
					i.length.should == 1 && i.first.should == Orgasm::X86::Instruction.new(:ADD,
						Orgasm::X86::Address.new(0x2000, 16), Orgasm::X86::Register.new(:dx))
				}
			end

			it 'disassembles ADD r8, m8' do
				disasm.do(%w(02 0e 00 20)).tap {|i|
					i.length.should == 1 && i.first.should == Orgasm::X86::Instruction.new(:ADD,
						Orgasm::X86::Register.new(:cl), Orgasm::X86::Address.new(0x2000, 16))
				}
			end

			it 'disassembles ADD r16, m16' do
				disasm.do(%w(03 16 00 20)).tap {|i|
					i.length.should == 1 && i.first.should == Orgasm::X86::Instruction.new(:ADD,
						Orgasm::X86::Register.new(:dx), Orgasm::X86::Address.new(0x2000, 16))
				}
			end
		end

		describe 'AND (Logical AND)' do
			it 'disassembles AND al, imm8' do
				disasm.do(%w(24 2a)).tap {|i|
					i.length.should == 1 && i.first.should == Orgasm::X86::Instruction.new(:AND,
						Orgasm::X86::Register.new(:al), Orgasm::X86::Immediate.new(42, 1))
				}
			end

			it 'disassembles AND ax, imm16' do
				disasm.do(%w(25 62 02)).tap {|i|
					i.length.should == 1 && i.first.should == Orgasm::X86::Instruction.new(:AND,
						Orgasm::X86::Register.new(:ax), Orgasm::X86::Immediate.new(610, 2))
				}
			end

			it 'disassembles AND r8, imm8' do
				disasm.do(%w(80 e3 2a)).tap {|i|
					i.length.should == 1 && i.first.should == Orgasm::X86::Instruction.new(:AND,
						Orgasm::X86::Register.new(:bl), Orgasm::X86::Immediate.new(42, 1))
				}
			end

			it 'disassembles AND r16, imm16' do
				disasm.do(%w(81 e3 13 09)).tap {|i|
					i.length.should == 1 && i.first.should == Orgasm::X86::Instruction.new(:AND,
						Orgasm::X86::Register.new(:bx), Orgasm::X86::Immediate.new(2323, 2))
				}
			end

			it 'disassembles AND r16, imm8' do
				disasm.do(%w(83 e3 2a)).tap {|i|
					i.length.should == 1 && i.first.should == Orgasm::X86::Instruction.new(:AND,
						Orgasm::X86::Register.new(:bx), Orgasm::X86::Immediate.new(42, 1))
				}
			end

			it 'disassembles AND r8, r8' do
				disasm.do(%w(20 d9)).tap {|i|
					i.length.should == 1 && i.first.should == Orgasm::X86::Instruction.new(:AND,
						Orgasm::X86::Register.new(:cl), Orgasm::X86::Register.new(:bl))
				}
			end

			it 'disassembles AND m8, r8' do
				disasm.do(%w(20 06 00 20)).tap {|i|
					i.length.should == 1 && i.first.should == Orgasm::X86::Instruction.new(:AND,
						Orgasm::X86::Address.new(0x2000, 8), Orgasm::X86::Register.new(:al))
				}
			end

			it 'disassembles AND r16, r16' do
				disasm.do(%w(21 d9)).tap {|i|
					i.length.should == 1 && i.first.should == Orgasm::X86::Instruction.new(:AND,
						Orgasm::X86::Register.new(:cx), Orgasm::X86::Register.new(:bx))
				}
			end

			it 'disassembles AND m16, r16' do
				disasm.do(%w(21 16 00 20)).tap {|i|
					i.length.should == 1 && i.first.should == Orgasm::X86::Instruction.new(:AND,
						Orgasm::X86::Address.new(0x2000, 16), Orgasm::X86::Register.new(:dx))
				}
			end

			it 'disassembles AND r8, m8' do
				disasm.do(%w(22 0e 00 20)).tap {|i|
					i.length.should == 1 && i.first.should == Orgasm::X86::Instruction.new(:AND,
						Orgasm::X86::Register.new(:cl), Orgasm::X86::Address.new(0x2000, 16))
				}
			end

			it 'disassembles AND r16, m16' do
				disasm.do(%w(23 16 00 20)).tap {|i|
					i.length.should == 1 && i.first.should == Orgasm::X86::Instruction.new(:AND,
						Orgasm::X86::Register.new(:dx), Orgasm::X86::Address.new(0x2000, 16))
				}
			end
		end
	end
end
