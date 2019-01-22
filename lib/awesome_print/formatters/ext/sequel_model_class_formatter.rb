require_relative '../base_formatter'

module AwesomePrint
  module Formatters
    class SequelModelClassFormatter < BaseFormatter

      formatter_for :sequel_model_class

      def self.formattable?(object)
        defined?(::Sequel::Model) && object.is_a?(Class) && object.ancestors.include?(::Sequel::Model)
      end

      def format(object)
        data = object.db_schema.inject({}) { |h, (prop, defn)| h.merge(prop => defn[:db_type]) }

        [
          "class #{colorize(object.to_s, :class)}",
          "< #{colorize(object.superclass.to_s, :class)}",
          Formatters::HashFormatter.new(@inspector).format(data)
        ].join(' ')
      end

    end
  end
end
