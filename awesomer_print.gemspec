# Copyright (c) 2010-2016 Michael Dvorkin and contributors
#
# Awesome Print is freely distributable under the terms of MIT license.
# See LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------

$:.push File.expand_path('../lib', __FILE__)
require 'awesomer_print/version'

Gem::Specification.new do |s|
  s.name        = 'awesomer_print'
  s.version     = AwesomerPrint.version
  s.authors     = ['Michael Dvorkin', 'Kevin McCormack']
  s.date        = Time.now.strftime('%Y-%m-%d')
  s.email       = 'harlemsquirrel@gmail.com'
  s.homepage    = 'https://github.com/awesomer-print/awesomer_print'
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
  s.add_development_dependency 'nokogiri', '>= 1.6.5'
  # s.add_development_dependency 'simplecov'
  # s.add_development_dependency 'codeclimate-test-reporter'
end
