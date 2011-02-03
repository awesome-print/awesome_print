# Copyright (c) 2010-2011 Michael Dvorkin
#
# Awesome Print is freely distributable under the terms of MIT license.
# See LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
#
# Running specs with Ruby 1.8.7 and RSpec 1.3+:
#   $ rake spec                           # Entire spec suite.
#   $ ruby -rubygems spec/logger_spec.rb  # Individual spec file.
#
# Running specs with Ruby 1.9.2 and RSpec 2.0+:
#   $ rake spec                           # Entire spec suite.
#   $ rspec spec/logger_spec.rb           # Individual spec file.
#
$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'ap'

if RUBY_VERSION.to_f < 1.9
  require 'spec'
  require 'spec/autorun'
  require 'rubygems'
end

def stub_dotfile!
  dotfile = File.join(ENV["HOME"], ".aprc")
  File.should_receive(:readable?).at_least(:once).with(dotfile).and_return(false)
end
