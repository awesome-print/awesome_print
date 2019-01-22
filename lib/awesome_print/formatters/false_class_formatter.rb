require_relative 'simple_formatter'

module AwesomePrint
  module Formatters
    class FalseClassFormatter < SimpleFormatter

      formatter_for :falseclass

      def self.formattable?(object)
        object == false
      end

    end
  end
end
