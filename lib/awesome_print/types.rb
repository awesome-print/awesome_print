module AwesomePrint
  module Types
    require 'awesome_print/types/base'
    require 'awesome_print/types/active_record' if defined?(ActiveRecord) || AwesomePrint.rails_console?
    require 'awesome_print/types/active_support' if defined?(ActiveSupport) || AwesomePrint.rails_console?
    require 'awesome_print/types/mongoid' if defined?(Mongoid)
  end
end
