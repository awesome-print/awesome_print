# Copyright (c) 2010-2016 Michael Dvorkin and contributors
#
# Awesome Print is freely distributable under the terms of MIT license.
# See LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
#
# AwesomePrint might be loaded implicitly through ~/.irbrc or ~/.pryrc
# so do nothing for subsequent requires.
#
unless defined?(AwesomePrint::Inspector)
  %w(awesome_method_array string method object class kernel).each do |file|
    require "awesome_print/core_ext/#{file}"
  end

  require 'awesome_print/custom_defaults'
  require 'awesome_print/inspector'
  require 'awesome_print/formatter'
  require 'awesome_print/version'
  require 'awesome_print/core_ext/logger' if defined?(Logger)
  #
  # Load the following under normal circumstances as well as in Rails
  # console when required from ~/.irbrc or ~/.pryrc.
  #
  require 'awesome_print/ext/active_record'  if defined?(ActiveRecord)  || AwesomePrint.rails_console?
  require 'awesome_print/ext/active_support' if defined?(ActiveSupport) || AwesomePrint.rails_console?
  #
  # Load remaining extensions.
  #
  if defined?(ActiveSupport.on_load)
    ActiveSupport.on_load(:action_view) do
      require 'awesome_print/ext/action_view'
    end
  end
  require 'awesome_print/ext/mongo_mapper'   if defined?(MongoMapper)
  require 'awesome_print/ext/mongoid'        if defined?(Mongoid)
  require 'awesome_print/ext/nokogiri'       if defined?(Nokogiri)
  require 'awesome_print/ext/nobrainer'      if defined?(NoBrainer)
  require 'awesome_print/ext/ripple'         if defined?(Ripple)
  require 'awesome_print/ext/sequel'         if defined?(Sequel)
  require 'awesome_print/ext/ostruct'        if defined?(OpenStruct)
end
