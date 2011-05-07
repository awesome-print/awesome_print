# Copyright (c) 2010-2011 Michael Dvorkin
#
# Awesome Print is freely distributable under the terms of MIT license.
# See LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
#
# Running specs from the command line:
#   $ rake spec                   # Entire spec suite.
#   $ rspec spec/logger_spec.rb   # Individual spec file.
#
$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'ap'

def stub_dotfile!
  dotfile = File.join(ENV["HOME"], ".aprc")
  File.should_receive(:readable?).at_least(:once).with(dotfile).and_return(false)
end

# Infinity Test runs tests as subprocesses, which sets STDOUT.tty? to false and 
# would otherwise prematurely disallow colors. We'll test the defaults later.
AwesomePrint.force_colors!
