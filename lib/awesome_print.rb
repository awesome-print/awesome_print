# Copyright (c) 2010-2011 Michael Dvorkin
#
# Awesome Print is freely distributable under the terms of MIT license.
# See LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
#
# AwesomePrint might be loaded implicitly through ~/.irbrc so do nothing
# for subsequent requires.
#
unless defined?(AwesomePrint::Formatter)
  %w(array string method object class kernel).each do |file|
    require File.dirname(__FILE__) + "/awesome_print/core_ext/#{file}"
  end

  require File.dirname(__FILE__) + "/awesome_print/inspector"
  require File.dirname(__FILE__) + "/awesome_print/formatter"
  require File.dirname(__FILE__) + "/awesome_print/version"
  require File.dirname(__FILE__) + "/awesome_print/core_ext/logger" if defined?(Logger)

  # Load the following under normal circumstances as well as in Rails
  # console when required from ~/.irbrc.
  require File.dirname(__FILE__) + "/awesome_print/ext/active_record"  if defined?(ActiveRecord)  || (defined?(IRB) && ENV['RAILS_ENV'])
  require File.dirname(__FILE__) + "/awesome_print/ext/active_support" if defined?(ActiveSupport) || (defined?(IRB) && ENV['RAILS_ENV'])

  # Load remaining extensions.
  require File.dirname(__FILE__) + "/awesome_print/ext/action_view"    if defined?(ActionView::Base)
  require File.dirname(__FILE__) + "/awesome_print/ext/mongo_mapper"   if defined?(MongoMapper)
  require File.dirname(__FILE__) + "/awesome_print/ext/mongoid"        if defined?(Mongoid)
  require File.dirname(__FILE__) + "/awesome_print/ext/nokogiri"       if defined?(Nokogiri)
end
