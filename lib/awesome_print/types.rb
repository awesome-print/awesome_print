module AwesomePrint
  module Types
    require 'awesome_print/types/active_record' if defined?(ActiveRecord) || AwesomePrint.rails_console?
  end
end
