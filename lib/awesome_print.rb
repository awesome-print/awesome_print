# Copyright (c) 2010 Michael Dvorkin
#
# Awesome Print is freely distributable under the terms of MIT license.
# See LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
#
# This is the copy of original 'ap.rb' file that matches the gem name. It makes
# it possible to omit the :require part in bundler's Gemfile:
#
# gem 'awesome_print', '>= 0.2.1', :require => 'ap'
# gem 'awesome_print', '>= 3.0.0'
#
require File.dirname(__FILE__) + "/ap/core_ext/array"
require File.dirname(__FILE__) + "/ap/core_ext/string"
require File.dirname(__FILE__) + "/ap/core_ext/object"
require File.dirname(__FILE__) + "/ap/core_ext/class"
require File.dirname(__FILE__) + "/ap/core_ext/kernel"
require File.dirname(__FILE__) + "/ap/awesome_print"

require File.dirname(__FILE__) + "/ap/core_ext/logger" if defined?(::Logger) or defined?(::ActiveSupport::BufferedLogger)

require File.dirname(__FILE__) + "/ap/mixin/action_view" if defined?(::ActionView)
require File.dirname(__FILE__) + "/ap/mixin/active_record" if defined?(::ActiveRecord)
require File.dirname(__FILE__) + "/ap/mixin/active_support" if defined?(::ActiveSupport)

