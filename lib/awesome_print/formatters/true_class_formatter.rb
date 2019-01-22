require_relative 'simple_formatter'

module AwesomePrint
  module Formatters
    class TrueClassFormatter < SimpleFormatter

      formatter_for :trueclass

      def self.formattable?(object)
        object == true
      end

    end
  end
end
