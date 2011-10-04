#! /usr/bin/env ruby
require 'rubygems'
require 'orgasm'
require 'orgasm/arch/x86'

describe 'Orgasm::Architecture(x86, i386)' do
	describe 'disassembler' do
		let :disasm do
			Orgasm::Architecture.x86[:i386].disassembler
		end

		describe 'real mode' do
			describe 'AAA (ASCII Adjust After Addition)' do
				it 'disassembles AAA' do
					disasm.do(%w(37), mode: :real).tap {|i|
						i.length.should == 1 && i.first.should == Orgasm::X86::Instruction.new(:AAA)
					}
				end
			end

			describe 'AAD (ASCII Adjust AX Before Division)' do
				it 'disassembles AAD' do
					disasm.do(%w(d5 0a), mode: :real).tap {|i|
						i.length.should == 1 && i.first.should == Orgasm::X86::Instruction.new(:AAD)
					}
				end

				it 'disassembles AAD imm8' do
					disasm.do(%w(d5 2a), mode: :real).tap {|i|
						i.length.should == 1 && i.first.should == Orgasm::X86::Instruction.new(:AAD,
							Orgasm::X86::Immediate.new(42, 1))
					}
				end
			end

			describe 'AAM (ASCII Adjust AX After Multiply)' do
				it 'disassembles AAM' do
					disasm.do(%w(d4 0a), mode: :real).tap {|i|
						i.length.should == 1 && i.first.should == Orgasm::X86::Instruction.new(:AAM)
					}
				end

				it 'disassembles AAM imm8' do
					disasm.do(%w(d4 17), mode: :real).tap {|i|
						i.length.should == 1 && i.first.should == Orgasm::X86::Instruction.new(:AAM,
							Orgasm::X86::Immediate.new(23, 1))
					}
				end
			end

			describe 'AAS (ASCII Adjust AL After Substraction)' do
				it 'disassembles AAS' do
					disasm.do(%w(3f), mode: :real).tap {|i|
						i.length.should == 1 && i.first.should == Orgasm::X86::Instruction.new(:AAS)
					}
				end

			end

			describe 'ADC (Add with Carry)' do
				it 'disassembles ADC al, imm8' do
					disasm.do(%w(14 2a), mode: :real).tap {|i|
						i.length.should == 1 && i.first.should == Orgasm::X86::Instruction.new(:ADC,
							Orgasm::X86::Register.new(:al), Orgasm::X86::Immediate.new(42, 1))
					}
				end

				it 'disassembles ADC ax, imm16' do
					disasm.do(%w(15 62 02), mode: :real).tap {|i|
						i.length.should == 1 && i.first.should == Orgasm::X86::Instruction.new(:ADC,
							Orgasm::X86::Register.new(:ax), Orgasm::X86::Immediate.new(610, 2))
					}
				end

				it 'disassembles ADC r8, imm8' do
					disasm.do(%w(80 d6 17), mode: :real).tap {|i|
						i.length.should == 1 && i.first.should == Orgasm::X86::Instruction.new(:ADC,
							Orgasm::X86::Register.new(:dh), Orgasm::X86::Immediate.new(23, 1))
					}
				end

				it 'disassembles ADC r16, imm16' do
					disasm.do(%w(81 d3 39 05), mode: :real).tap {|i|
						i.length.should == 1 && i.first.should == Orgasm::X86::Instruction.new(:ADC,
							Orgasm::X86::Register.new(:bx), Orgasm::X86::Immediate.new(1337, 2))
					}
				end

				it 'disassembles ADC r16, imm8' do
					disasm.do(%w(83 d1 2a), mode: :real).tap {|i|
						i.length.should == 1 && i.first.should == Orgasm::X86::Instruction.new(:ADC,
							Orgasm::X86::Register.new(:cx), Orgasm::X86::Immediate.new(42, 1))
					}
				end

				it 'disassembles ADC r8, r8' do
					disasm.do(%w(10 d9), mode: :real).tap {|i|
						i.length.should == 1 && i.first.should == Orgasm::X86::Instruction.new(:ADC,
							Orgasm::X86::Register.new(:cl), Orgasm::X86::Register.new(:bl))
					}
				end

				it 'disassembles ADC m8, r8' do
					disasm.do(%w(10 06 00 20), mode: :real).tap {|i|
						i.length.should == 1 && i.first.should == Orgasm::X86::Instruction.new(:ADC,
							Orgasm::X86::Address.new(0x2000, 8), Orgasm::X86::Register.new(:al))
					}
				end

				it 'disassembles ADC r16, r16' do
					disasm.do(%w(11 d9), mode: :real).tap {|i|
						i.length.should == 1 && i.first.should == Orgasm::X86::Instruction.new(:ADC,
							Orgasm::X86::Register.new(:cx), Orgasm::X86::Register.new(:bx))
					}
				end

				it 'disassembles ADC m16, r16' do
					disasm.do(%w(11 16 00 20), mode: :real).tap {|i|
						i.length.should == 1 && i.first.should == Orgasm::X86::Instruction.new(:ADC,
							Orgasm::X86::Address.new(0x2000, 16), Orgasm::X86::Register.new(:dx))
					}
				end
			end

			describe 'ADD (Add)' do
				it 'disassembles ADD al, imm8' do
					disasm.do(%w(04 2a), mode: :real).tap {|i|
						i.length.should == 1 && i.first.should == Orgasm::X86::Instruction.new(:ADD,
							Orgasm::X86::Register.new(:al), Orgasm::X86::Immediate.new(42, 1))
					}
				end

				it 'disassembles ADD ax, imm16' do
					disasm.do(%w(05 39 05), mode: :real).tap {|i|
						i.length.should == 1 && i.first.should == Orgasm::X86::Instruction.new(:ADD,
							Orgasm::X86::Register.new(:ax), Orgasm::X86::Immediate.new(1337, 2))
					}
				end

				it 'disassembles ADD r8, imm8' do
					disasm.do(%w(80 c3 2a), mode: :real).tap {|i|
						i.length.should == 1 && i.first.should == Orgasm::X86::Instruction.new(:ADD,
							Orgasm::X86::Register.new(:bl), Orgasm::X86::Immediate.new(42, 1))
					}
				end
			end
		end

		describe 'protected mode' do
		end
	end
end
