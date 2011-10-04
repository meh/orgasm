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

require 'stringio'

module Orgasm

class Disassembler < Piece
	attr_reader :inherits, :supports

	def initialize (*)
		@inherits = []
		@decoders = []
		@supports = []

		super
	end

	def supports (name)
		@supports << name
		@supports.uniq!
		@supports
	end

	def supports? (name)
		@supports.member?(name)
	end

	def inherit (*args)
		@inherits << args

		@inherits.flatten!
		@inherits.compact!

		self
	end

	def disassemble (io, options={})
		options = {
			extensions: []
		}.merge(options)

		options.each_key {|name|
			next if [:extensions, :exceptions, :limit, :unknown, :inherited].member?(name)

			unless supports?(name)
				raise ArgumentError, "#{name} is an unsupported option"
			end
		}

		if io.is_a?(Array)
			io = io.map { |b| [b.hex].pack(bytes: (b.hex.to_s(16).length / 2.0).ceil) }.join ''
		end

		if io.is_a?(String)
			io = StringIO.new(io)
		end

		options[:extensions].clone.each {|name|
			unless arch.extensions.all? { |extension| extension.name == extension && extension.disassembler }
				if options[:exceptions] == false
					options[:extensions].delete(name)
				else
					raise ArgumentError, "#{name} isn't supported by #{arch.name}"
				end
			end
		}

		result = []
		junk   = nil

		until io.eof?
			where = io.tell

			begin
				added = @decoders.any? {|decoder|
					decoded = decoder.for(io, options).decode

					if Orgasm.object?(decoded) || decoded.is_a?(Orgasm::True)
						instance_eval &@after if @after
						
						result << unknown(junk) and junk = nil if junk
						result << decoded                      unless decoded.is_a?(Orgasm::True)

						true
					end
				}

				if !added
					io.seek where unless (@inherits + options[:extensions].map {|name|
						arch.extensions.select {|extension|
							extension.name == name
						}
					}).flatten.compact.any? {|arch|
						io.seek where

						if tmp = arch.disassembler.disassemble(io, options.merge(limit: 1, unknown: false, inherited: true, exceptions: false)).first
							result << unknown(junk) and junk = nil if junk
							result << tmp
						end
					}
				end
			rescue NeedMoreData
				io.seek where

				(junk ||= '') << io.read
			end

			break if options[:limit] && result.flatten.compact.length >= options[:limit]

			if where == io.tell
				break if options[:unknown] == false
					
				(junk ||= '') << io.read(1)
			end
		end

		result << unknown(junk) if junk

		result.flatten.compact
	end; alias do disassemble

	def on (*args, &block)
		@decoders << Decoder.new(self, *args, &block)
	end

	def always (&block)
		@decoders << Decoder.new(self, true, &block)
	end

	def unknown (data=nil, &block)
		if block
			@unknown = block
		elsif data
			if @unknown
				instance_exec data, &@unknown
			else
				instance_exec data do |data|
					Unknown.new(data)
				end
			end
		end
	end

	def skip (&block)
		@skip ||= block
	end

	def after (&block)
		@after ||= block
	end

	def | (value)
		Pipeline.new(self, value)
	end
end

end

require 'orgasm/disassembler/decoder'
require 'orgasm/disassembler/pipeline'
