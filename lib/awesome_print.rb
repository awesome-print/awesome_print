# Copyright (c) 2010-2011 Michael Dvorkin
#
# Awesome Print is freely distributable under the terms of MIT license.
# See LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
#
# This is the copy of original 'ap.rb' file that matches the gem name. It makes
# it possible to omit the :require part in bundler's Gemfile:
#
# gem 'awesome_print', '>= 0.4.0'
#
unless defined?(AwesomePrint)
  %w(array string method object class kernel).each do |file|
    require File.dirname(__FILE__) + "/awesome_print/core_ext/#{file}"
  end

  require File.dirname(__FILE__) + "/awesome_print/inspector"
  require File.dirname(__FILE__) + "/awesome_print/formatter"
  require File.dirname(__FILE__) + "/awesome_print/core_ext/logger" if defined?(Logger)
  require File.dirname(__FILE__) + "/awesome_print/ext/action_view" if defined?(ActionView)

  # Load the following under normal circumstatnces as well as in Rails
  # console when required from ~/.irbrc.
  require File.dirname(__FILE__) + "/awesome_print/ext/active_record"  if defined?(ActiveRecord)  || (defined?(IRB) && ENV['RAILS_ENV'])
  require File.dirname(__FILE__) + "/awesome_print/ext/active_support" if defined?(ActiveSupport) || (defined?(IRB) && ENV['RAILS_ENV'])
  require File.dirname(__FILE__) + "/awesome_print/ext/mongo_mapper"   if defined?(MongoMapper)
end
