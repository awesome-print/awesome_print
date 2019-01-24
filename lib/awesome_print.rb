require 'awesome_print/formatters'
require 'awesome_print/inspector'
require 'awesome_print/formatter'
require 'awesome_print/version'

module AwesomePrint
  class << self
    attr_accessor :defaults, :force_colors

    # Class accessor to force colorized output (ex. forked subprocess where TERM
    # might be dumb).
    #---------------------------------------------------------------------------
    def force_colors!(value = true)
      @force_colors = value
    end
  end
end

# CORE EXTENSIONS... now that ap is loaded, inject awesome behavior into ruby
%w(awesome_method_array string object class kernel logger active_support).each do |file|
  require "awesome_print/core_ext/#{file}"
end

# FIXME: not sure we need these, but..
require 'awesome_print/custom_defaults'

