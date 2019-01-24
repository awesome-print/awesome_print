require_relative 'simple_formatter'

module AwesomePrint
  module Formatters
    class NilClassFormatter < SimpleFormatter

      formatter_for :nilclass

      def self.formattable?(object)
        object == nil
      end

      def format(object)
        colorize('nil', self.class.formatted_object_type)
      end

    end
  end
end
