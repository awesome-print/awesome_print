require "bundler"
Bundler::GemHelper.install_tasks

task :default => :spec

desc "Run all awesome_print gem specs"
task :spec do
  # Run plain rspec command without RSpec::Core::RakeTask overrides.
  exec "rspec -c spec"
end

