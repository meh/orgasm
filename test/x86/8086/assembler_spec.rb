require 'rubygems'
require 'orgasm'
require 'orgasm/arch/x86'

describe 'Orgasm::Architecture(x86, 8086)' do
	describe 'assembler' do
		let :asm do
			Orgasm::Architecture.x86[8086].assembler
		end

		describe 'AAA (ASCII Adjust After Addition)' do
			it 'assembles AAA' do
				asm.do(Orgasm::X86::Instruction.new(:AAA)).tap {|s|
					s.should == %w(37).to_opcodes
				}
			end
		end

		describe 'AAD (ASCII Adjust AX Before Division)' do
			it 'assembles AAD' do
				asm.do(Orgasm::X86::Instruction.new(:AAD)).tap {|s|
					s.should == %w(d5 0a).to_opcodes
				}
			end

			it 'assembles AAD imm8' do
				asm.do(Orgasm::X86::Instruction.new(:AAD, Orgasm::X86::Immediate.new(42, 8))).tap {|s|
					s.should == %w(d5 2a).to_opcodes
				}
			end
		end
	end
end
