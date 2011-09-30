#! /usr/bin/env ruby
require 'rubygems'
require 'orgasm'
require 'orgasm/arch/x86'

describe 'Orgasm::Architecture(x86, 8086)' do
	describe 'disassembler' do
		let :disasm do
			Orgasm::Architecture.x86[8086].disassembler
		end

		it 'should decode ADD properly' do
			disasm.disassemble("\xc1\x83\x00\x36").tap {|i|
				i.length.should == 1 && i.first.should == Orgasm::X86::Instruction.new(:ADD,
					Orgasm::X86::Register.new(:ax), Orgasm::X86::Immediate.new(0x36, 1))
			}
		end
	end
end
