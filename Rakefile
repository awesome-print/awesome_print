require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "awesome_print"
    gem.rubyforge_project = "awesome_print"
    gem.summary = %Q{Pretty print Ruby objects with proper indentation and colors.}
    gem.description = %Q{Great Ruby dubugging companion: pretty print Ruby objects to visualize their structure. Supports Rails ActiveRecord objects via included mixin.}
    gem.email = "mike@dvorkin.net"
    gem.homepage = "http://github.com/michaeldv/awesome_print"
    gem.authors = ["Michael Dvorkin"]
    if RUBY_VERSION.to_f >= 1.9
      gem.add_development_dependency "rspec", ">= 2.0.0"
    else
      gem.add_development_dependency "rspec", ">= 1.3.0"
    end
    gem.files = FileList["[A-Z]*", "lib/**/*.rb", "rails/*.rb", "spec/*", "init.rb"]
    gem.has_rdoc = false
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

if RUBY_VERSION.to_f >= 1.9
  require "rspec/core/rake_task" # RSpec 2.0
  RSpec::Core::RakeTask.new(:spec) do |spec|
    spec.pattern = 'spec/**/*_spec.rb'
    spec.rspec_opts = ['--color']
  end

  RSpec::Core::RakeTask.new(:rcov) do |spec|
    spec.rcov = true
    spec.rcov_opts =  %q[--exclude "spec"]
  end
else
  require 'spec/rake/spectask'
  Spec::Rake::SpecTask.new(:spec) do |spec|
    spec.libs << 'lib' << 'spec'
    spec.spec_opts = ['--color']
    spec.spec_files = FileList['spec/**/*_spec.rb']
  end

  Spec::Rake::SpecTask.new(:rcov) do |spec|
    spec.libs << 'lib' << 'spec'
    spec.pattern = 'spec/**/*_spec.rb'
    spec.rcov = true
  end
end

task :spec => :check_dependencies

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

 rdoc.rdoc_dir = 'rdoc'
 rdoc.title = "ap #{version}"
 rdoc.rdoc_files.include('README*')
 rdoc.rdoc_files.include('lib/**/*.rb')
end
