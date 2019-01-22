require_relative 'simple_formatter'

module AwesomePrint
  module Formatters
    class SymbolFormatter < SimpleFormatter

      formatter_for :symbol

      def self.formattable?(object)
        object.respond_to?(:to_s)
      end

      def format(object)
        colorize(":#{object.to_s}", self.class.formatted_object_type)
      end
    end
  end
end
