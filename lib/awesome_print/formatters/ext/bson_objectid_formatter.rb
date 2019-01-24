require_relative '../base_formatter'

module AwesomePrint
  module Formatters
    class BsonObjectidFormatter < BaseFormatter

      formatter_for :bson_objectid

      def self.formattable?(object)
        (defined?(::BSON) && object.is_a?(::BSON::ObjectId)) ||
          (defined?(::Moped::BSON) && object.is_a?(::Moped::BSON::ObjectId))
      end

      def format(object)
        colorize(object.inspect, self.class.formatted_object_type)
      end

    end
  end
end
