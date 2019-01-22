# AwesomePrint might be loaded implicitly through ~/.irbrc or ~/.pryrc
# so do nothing for subsequent requires.
#
unless defined?(AwesomePrint::Inspector)
  %w(active_support awesome_method_array string object class kernel).each do |file|
    require "awesome_print/core_ext/#{file}"
  end

  require 'awesome_print/custom_defaults'
  require 'awesome_print/inspector'
  require 'awesome_print/formatter'

  Dir["./lib/awesome_print/formatters/**/*.rb"].each { |f| require f }

  require 'awesome_print/version'
  require 'awesome_print/core_ext/logger' if defined?(Logger)
end
