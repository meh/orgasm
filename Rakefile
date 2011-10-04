#! /usr/bin/env ruby
require 'rake'

task :default => :test

task :test do
  Dir.chdir 'test'

  sh 'rspec x86/8086_spec.rb x86/i386_spec.rb --color --format doc'
end
