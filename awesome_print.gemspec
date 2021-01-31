# Copyright (c) 2010-2016 Michael Dvorkin and contributors
#
# Awesome Print is freely distributable under the terms of MIT license.
# See LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------

$:.push File.expand_path('../lib', __FILE__)
require 'awesome_print/version'

Gem::Specification.new do |s|
  s.name        = 'awesome_print'
  s.version     = AwesomePrint.version
  s.authors     = 'Michael Dvorkin'
  s.date        = Time.now.strftime('%Y-%m-%d')
  s.email       = 'mike@dvorkin.net'
  s.homepage    = 'https://github.com/awesome-print/awesome_print'
  s.summary     = 'Pretty print Ruby objects with proper indentation and colors'
  s.description = 'Great Ruby debugging companion: pretty print Ruby objects to visualize their structure. Supports custom object formatting via plugins'
  s.license     = 'MIT'

  s.files         = Dir['[A-Z]*[^~]'] + Dir['lib/**/*.rb'] + Dir['spec/**/*'] + ['.gitignore']
  s.test_files    = Dir['spec/**/*']
  s.executables   = []
  s.require_paths = ['lib']

  s.add_development_dependency 'rspec',  '>= 3.0.0'
  s.add_development_dependency 'appraisal'
  s.add_development_dependency 'fakefs', '>= 0.2.1'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'nokogiri', '>= 1.11.0'
  # s.add_development_dependency 'simplecov'
  # s.add_development_dependency 'codeclimate-test-reporter'
end
