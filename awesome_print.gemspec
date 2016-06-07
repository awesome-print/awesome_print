Gem::Specification.new do |s|
  s.name        = "awesome_print"
  s.version     = "1.7.0"
  s.authors     = "Michael Dvorkin"
  s.date        = Time.now.strftime("%Y-%m-%d")
  s.email       = "mike@dvorkin.net"
  s.homepage    = "https://github.com/awesome-print/awesome_print"
  s.summary     = "Pretty print Ruby objects with proper indentation and colors"
  s.description = "Great Ruby dubugging companion: pretty print Ruby objects to visualize their structure. Supports custom object formatting via plugins"
  s.license     = "MIT"
  s.rubyforge_project = "awesome_print"

  s.files         = Dir["[A-Z]*[^~]"] + Dir["lib/**/*.rb"] + Dir["spec/*"] + [".gitignore"]
  s.test_files    = Dir["spec/*"]
  s.executables   = []
  s.require_paths = ["lib"]

  s.add_development_dependency "rspec",  ">= 3.0.0"
  s.add_development_dependency "appraisal"
  s.add_development_dependency "fakefs", ">= 0.2.1"
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'nokogiri', '>= 1.6.5'
  s.add_development_dependency 'codeclimate-test-reporter'
end
