Kernel.load 'lib/orgasm/version.rb'

Gem::Specification.new {|s|
  s.name         = 'orgasm'
  s.version      = Orgasm.version
  s.author       = 'meh.'
  s.email        = 'meh@paranoici.org'
  s.homepage     = 'http://github.com/meh/refr'
  s.platform     = Gem::Platform::RUBY
  s.summary      = 'A Ruby (dis)?assembler library.'
  s.files        = Dir.glob('lib/**/*.rb')
  s.require_path = 'lib'
  s.executables  = ['disorgasm']
}
