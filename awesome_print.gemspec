# Copyright (c) 2010-2013 Michael Dvorkin
#
# Awesome Print is freely distributable under the terms of MIT license.
# See LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
require "rake"

Gem::Specification.new do |s|
  s.name        = "awesome_print"
  s.version     = "1.2.0"
# s.platform    = Gem::Platform::RUBY
  s.authors     = "Michael Dvorkin"
  s.date        = Time.now.strftime("%Y-%m-%d")
  s.email       = "mike@dvorkin.net"
  s.homepage    = "http://github.com/michaeldv/awesome_print"
  s.summary     = "Pretty print Ruby objects with proper indentation and colors"
  s.description = "Great Ruby dubugging companion: pretty print Ruby objects to visualize their structure. Supports custom object formatting via plugins"
  s.license     = "MIT"
  s.rubyforge_project = "awesome_print"

  s.files         = Dir["[A-Z]*[^~]"] + Dir["lib/**/*.rb"] + Dir["spec/*"] + [".gitignore"]
  s.test_files    = Dir["spec/*"]
  s.executables   = []
  s.require_paths = ["lib"]

  s.add_development_dependency "rspec",  ">= 3.0.0"
  s.add_development_dependency "fakefs", ">= 0.2.1"
end
