require 'bundler'
Bundler::GemHelper.install_tasks

require "rake"
require File.dirname(__FILE__) + "/lib/awesome_print/version"

task :default => :spec

desc "Run all awesome_print gem specs"
task :spec do
  # Run plain rspec command without RSpec::Core::RakeTask overrides.
  exec "rspec -c spec"
end