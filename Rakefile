#! /usr/bin/env ruby
require 'rake'

task :default => :test

task :test do
  sh "rspec #{Dir['test/**/**_spec.rb'].join ' '} --color --format doc"
end
