# Copyright (c) 2010-2016 Michael Dvorkin and contributors
#
# Awesome Print is freely distributable under the terms of MIT license.
# See LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
#
# AwesomerPrint might be loaded implicitly through ~/.irbrc or ~/.pryrc
# so do nothing for subsequent requires.
#
unless defined?(AwesomerPrint::Inspector)
  %w(awesome_method_array string method object class kernel).each do |file|
    require "awesomer_print/core_ext/#{file}"
  end

  require 'awesomer_print/custom_defaults'
  require 'awesomer_print/inspector'
  require 'awesomer_print/formatter'
  require 'awesomer_print/version'
  require 'awesomer_print/core_ext/logger' if defined?(Logger)
  #
  # Load the following under normal circumstances as well as in Rails
  # console when required from ~/.irbrc or ~/.pryrc.
  #
  require 'awesomer_print/ext/active_record'  if defined?(ActiveRecord)  || AwesomerPrint.rails_console?
  require 'awesomer_print/ext/active_support' if defined?(ActiveSupport) || AwesomerPrint.rails_console?
  #
  # Load remaining extensions.
  #
  if defined?(ActiveSupport.on_load)
    ActiveSupport.on_load(:action_view) do
      require 'awesomer_print/ext/action_view'
    end
  end
  require 'awesomer_print/ext/mongo_mapper'   if defined?(MongoMapper)
  require 'awesomer_print/ext/mongoid'        if defined?(Mongoid)
  require 'awesomer_print/ext/nokogiri'       if defined?(Nokogiri)
  require 'awesomer_print/ext/nobrainer'      if defined?(NoBrainer)
  require 'awesomer_print/ext/ripple'         if defined?(Ripple)
  require 'awesomer_print/ext/sequel'         if defined?(Sequel)
  require 'awesomer_print/ext/ostruct'        if defined?(OpenStruct)
end
