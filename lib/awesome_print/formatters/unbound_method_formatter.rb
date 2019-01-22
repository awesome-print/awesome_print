require_relative 'method_formatter'

module AwesomePrint
  module Formatters
    class UnboundMethodFormatter < MethodFormatter

      formatter_for :unboundmethod

      def self.formattable?(object)
        object.is_a?(UnboundMethod)
      end

    end
  end
end
