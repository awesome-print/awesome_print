module AwesomePrint
  module Formatters
    class Unboundmethod < Formatter

      def call
        AwesomePrint::Formatters::Method.new(formatter, object).call
      end
    end
  end
end
