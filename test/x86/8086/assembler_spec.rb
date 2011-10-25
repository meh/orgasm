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
				%w(37).to_opcodes.should == asm.do(Orgasm::X86::Instruction.new(:AAA))
			end
		end

		describe 'AAD (ASCII Adjust AX Before Division)' do
			it 'assembles AAD' do
				%w(d5 0a).to_opcodes.should == asm.do(Orgasm::X86::Instruction.new(:AAD))
			end

			it 'assembles AAD imm8' do
				%w(d5 2a).to_opcodes.should == asm.do(Orgasm::X86::Instruction.new(:AAD,
					Orgasm::X86::Immediate.new(42, 8)))
			end
		end
	end
end
