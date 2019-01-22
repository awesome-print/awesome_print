require_relative 'base_formatter'

module AwesomePrint
  module Formatters
    class BigdecimalFormatter < BaseFormatter

      formatter_for :bigdecimal

      def self.formattable?(object)
        true
      end

      def format(object)
        colorize(object.to_s('F'), self.class.formatted_object_type)
      end

    end
  end
end
