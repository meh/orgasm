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
		end

		describe 'protected mode' do
		end
	end
end
