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

class Disassembler < Piece
	attr_reader :inherits, :supports, :options

	def initialize (*)
		@inherits = []
		@decoders = []
		@supports = []
		@options  = {}

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

	def with (options)
		clone.tap {|disasm|
			disasm.instance_eval {
				@options = options
			}
		}
	end

	def disassemble (io, options={})
		if options[:extensions] && @options[:extensions]
			options[:extensions].unshift(*@options[:extensions])
		end

		options = @options.merge(options)

		options.each_key {|name|
			next if %w(extensions exceptions limit unknown inherited).to_syms.member?(name)

			unless supports?(name) || options[:exceptions] == false
				raise ArgumentError, "#{name} is an unsupported option"
			end
		}

		io = io.to_opcodes    if io.is_a?(Array)
		io = StringIO.new(io) if io.is_a?(String)

		extensions = (options[:extensions] || []).dup
		
		extensions.dup.each {|name|
			unless arch.extensions.all? { |extension| extension.name.to_s.downcase == extension.to_s.downcase && extension.disassembler }
				if options[:exceptions] == false
					extensions.delete(name)
				else
					raise ArgumentError, "#{name} isn't supported by #{arch.name}"
				end
			end
		}

		extensions.tap {|exts|
			next unless exts.is_a?(Array)

			exts.map! {|name|
				arch.extensions.select {|extension|
					extension.name.to_s.downcase == name.to_s.downcase
				}
			}

			exts.flatten!
			exts.compact!
		}

		result   = []
		junk     = nil
		decoders = @decoders.map { |d| d.for(io, options) }

		until io.eof?
			where = io.tell

			added = decoders.any? {|decoder|
				decoded = begin
					decoder.decode
				rescue
					raise unless options[:exceptions] == false
				end

				if Orgasm.object?(decoded)
					instance_eval &after if after
					
					result << unknown(junk) and junk = nil if junk
					result << decoded                      unless decoded.is_a?(Orgasm::True)

					true
				end
			}

			if !added
				io.seek where unless (@inherits + extensions).any? {|arch|
					io.seek where
					
					decoded = begin
						arch.disassembler.disassemble(io, options.merge(limit: 1, unknown: false, inherited: true, exceptions: false)).first
					rescue
						raise unless options[:exceptions] == false
					end

					if decoded
						result << unknown(junk) and junk = nil if junk
						result << decoded
					end
				}
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
		block ? @skip = block : @skip
	end

	def after (&block)
		block ? @after = block : @after
	end

	def | (value)
		Pipeline.new(self, value)
	end
end

end

require 'orgasm/disassembler/decoder'
require 'orgasm/disassembler/pipeline'
