#
# AwesomePrint might be loaded implicitly through ~/.irbrc or ~/.pryrc
# so do nothing for subsequent requires.
#
unless defined?(AwesomePrint::Inspector)
  %w(array string method object class kernel).each do |file|
    require "awesome_print/core_ext/#{file}"
  end

  require 'awesome_print/support'
  require 'awesome_print/configuration'
  require 'awesome_print/inspector'
  require 'awesome_print/formatter'
  require 'awesome_print/version'
  require 'awesome_print/core_ext/logger' if defined?(Logger)

  #
  # Load remaining extensions.
  #
  if defined?(ActiveSupport)
    ActiveSupport.on_load(:action_view) do
      require 'awesome_print/ext/action_view'
    end
  end
end
