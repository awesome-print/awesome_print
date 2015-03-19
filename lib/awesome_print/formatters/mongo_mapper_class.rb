require 'awesome_print/formatters/mongo_mapper'

module AwesomePrint
  module Formatters
    class MongoMapperClass < Formatter
      include MongoMapper

      def call
        return object.inspect if !defined?(::ActiveSupport::OrderedHash) || !object.respond_to?(:keys)

        "class #{object} < #{object.superclass} " <<  AwesomePrint::Formatters::Hash.new(formatter, columns).call
      end

      private

        def columns
          data = object.keys.sort.inject(::ActiveSupport::OrderedHash.new) do |hash, c|
            hash[c.first] = (c.last.type || "undefined").to_s.underscore.intern
            hash
          end

          # Add in associations
          if options[:mongo_mapper][:show_associations]
            object.associations.each do |name, assoc|
              data[name.to_s] = assoc
            end
          end
          data
        end
    end
  end
end
