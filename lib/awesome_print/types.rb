module AwesomePrint
  module Types
    require 'awesome_print/types/base'
    require 'awesome_print/types/active_record' if defined?(ActiveRecord) || AwesomePrint.rails_console?
    require 'awesome_print/types/active_support' if defined?(ActiveSupport) || AwesomePrint.rails_console?
    require 'awesome_print/types/mongoid' if defined?(Mongoid)
    require 'awesome_print/types/mongo_mapper' if defined?(MongoMapper)
    require 'awesome_print/types/no_brainer' if defined?(NoBrainer)
    require 'awesome_print/types/nokogiri' if defined?(Nokogiri)
    require 'awesome_print/types/ostruct' if defined?(OpenStruct)
  end
end
