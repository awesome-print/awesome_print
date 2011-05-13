# Copyright (c) 2010-2011 Michael Dvorkin
#
# Awesome Print is freely distributable under the terms of MIT license.
# See LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
#
# AwesomePrint might be loaded implicitly through ~/.irbrc so do nothing
# for subsequent requires.
#
unless defined?(AwesomePrint)
  %w(array string method object class kernel).each do |file|
    require File.dirname(__FILE__) + "/ap/core_ext/#{file}"
  end

  require File.dirname(__FILE__) + "/ap/awesome_print"
  require File.dirname(__FILE__) + "/ap/core_ext/logger"   if defined?(Logger)
  require File.dirname(__FILE__) + "/ap/mixin/action_view" if defined?(ActionView)

  # Load the following under normal circumstatnces as well as in Rails
  # console when required from ~/.irbrc.
  require File.dirname(__FILE__) + "/ap/mixin/active_record"  if defined?(ActiveRecord)  || (defined?(IRB) && ENV['RAILS_ENV'])
  require File.dirname(__FILE__) + "/ap/mixin/active_support" if defined?(ActiveSupport) || (defined?(IRB) && ENV['RAILS_ENV'])
  require File.dirname(__FILE__) + "/ap/mixin/mongo_mapper"   if defined?(MongoMapper)
end
