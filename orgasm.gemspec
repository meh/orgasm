Kernel.load 'lib/orgasm/version.rb'

Gem::Specification.new {|s|
	s.name         = 'orgasm'
	s.version      = Orgasm.version
	s.author       = 'meh.'
	s.email        = 'meh@paranoici.org'
	s.homepage     = 'http://github.com/meh/orgasm'
	s.platform     = Gem::Platform::RUBY
	s.summary      = 'A Ruby (dis)?assembler library.'

	s.files         = `git ls-files`.split("\n")
	s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
	s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
	s.require_paths = ['lib']

	s.add_dependency 'call-me'
	s.add_dependency 'packable'
	s.add_dependency 'blankslate'

	s.add_development_dependency 'rake'
	s.add_development_dependency 'rspec'
}
