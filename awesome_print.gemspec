# Copyright (c) 2010-2011 Michael Dvorkin
#
# Awesome Print is freely distributable under the terms of MIT license.
# See LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
require "rake"
require File.dirname(__FILE__) + "/lib/awesome_print/version"

task :default => :spec

desc "Run all awesome_print gem specs"
task :spec do
  # Run plain rspec command without RSpec::Core::RakeTask overrides.
  exec "rspec -c spec"
end

Gem::Specification.new do |s|
  s.name        = "awesome_print"
  s.version     = AwesomePrint.version
# s.platform    = Gem::Platform::RUBY
  s.authors     = "Michael Dvorkin"
  s.date        = "2011-11-08"
  s.email       = "mike@dvorkin.net"
  s.homepage    = "http://github.com/michaeldv/awesome_print"
  s.summary     = "Pretty print Ruby objects with proper indentation and colors"
  s.description = "Great Ruby dubugging companion: pretty print Ruby objects to visualize their structure. Supports custom object formatting via plugins"

  s.rubyforge_project = "awesome_print"

  s.files         = Rake::FileList["[A-Z]*", "lib/**/*.rb", "spec/*", ".gitignore"]
  s.test_files    = Rake::FileList["spec/*"]
  s.executables   = []
  s.require_paths = ["lib"]

  s.add_development_dependency "rspec",  ">= 2.6.0"
  s.add_development_dependency "fakefs", ">= 0.2.1"
end
