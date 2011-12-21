# Copyright (c) 2010-2011 Michael Dvorkin
#
# Awesome Print is freely distributable under the terms of MIT license.
# See LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
#
# AwesomePrint might be loaded implicitly through ~/.irbrc so do nothing
# for subsequent requires.
#
%w(array string method object class kernel).each do |file|
  require "awesome_print/core_ext/#{file}"
end

require 'awesome_print/inspector'
require 'awesome_print/formatter'
require 'awesome_print/version'
require 'awesome_print/core_ext/logger' if defined?(Logger)

is_rails_console = (defined?(IRB) || defined?(Pry)) && ENV['RAILS_ENV']

# Load the following under normal circumstances as well as in Rails
# console when required from ~/.irbrc.
if defined?(ActiveRecord::Base) || is_rails_console
  require 'awesome_print/ext/active_record'
end
if defined?(ActiveSupport) || is_rails_console
  require 'awesome_print/ext/active_support'
end

# Load remaining extensions.
require 'awesome_print/ext/action_view'    if defined?(ActionView::Base)
require 'awesome_print/ext/mongo_mapper'   if defined?(MongoMapper::Document)
require 'awesome_print/ext/mongoid'        if defined?(Mongoid::Document)
require 'awesome_print/ext/nokogiri'       if defined?(Nokogiri)
