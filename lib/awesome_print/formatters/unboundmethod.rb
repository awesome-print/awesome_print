module AwesomePrint
  module Formatters
    class Unboundmethod < Base

      def call
        AwesomePrint::Formatters::Method.new(formatter, object).call
      end
    end
  end
end
