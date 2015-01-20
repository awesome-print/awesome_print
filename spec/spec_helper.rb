# Copyright (c) 2010-2013 Michael Dvorkin
#
# Awesome Print is freely distributable under the terms of MIT license.
# See LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
#
# Running specs from the command line:
#   $ rake spec                   # Entire spec suite.
#   $ rspec spec/objects_spec.rb  # Individual spec file.
#
# NOTE: To successfully run specs with Ruby 1.8.6 the older versions of
# Bundler and RSpec gems are required:
#
# $ gem install bundler -v=1.0.2
# $ gem install rspec -v=2.6.0
#
require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start
$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

Dir[File.dirname(__FILE__) + '/support/**/*.rb'].each do |file|
  require file
end

ExtVerifier.require_dependencies!(%w{rails active_record action_view
                                  active_support/all mongoid mongo_mapper ripple nobrainer})
require 'nokogiri'
require 'awesome_print'

RSpec.configure do |config|
  config.disable_monkey_patching!
  # TODO: Make specs not order dependent
  # config.order = :random
  Kernel.srand config.seed
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
  end
  config.mock_with :rspec do |mocks|
    mocks.syntax = :expect
    mocks.verify_partial_doubles = true
  end
  if config.files_to_run.one?
    config.default_formatter = 'doc'
  end
end

def stub_dotfile!
  dotfile = File.join(ENV["HOME"], ".aprc")
  expect(File).to receive(:readable?).at_least(:once).with(dotfile).and_return(false)
end

def capture!
  standard, $stdout = $stdout, StringIO.new
  yield
ensure
  $stdout = standard
end
