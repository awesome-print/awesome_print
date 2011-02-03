# Copyright (c) 2010-2011 Michael Dvorkin
#
# Awesome Print is freely distributable under the terms of MIT license.
# See LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
#
# Load awesome_print when installed as Rails 2.3.x plugin.
#
# NOTE: After Rails 2.3.x console loads awesome_print/lib/ap.rb it attempts
# to load this file as well.  Make sure to check whether the awesome_print
# is already loaded to avoid Ruby stack overflow when extending core classes.
#
require File.join(File.dirname(__FILE__), "..", "init") unless defined?(AwesomePrint)
