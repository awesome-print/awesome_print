require_relative 'base_formatter'

module AwesomePrint
  module Formatters
    class SimpleFormatter < BaseFormatter

      formatter_for :simple

      def self.core?
        true
      end

      def self.formattable?(object)
        object.respond_to?(:to_s)
      end

      def format(object)
        colorize(object.to_s, self.class.formatted_object_type)
      end

    end
  end
end
