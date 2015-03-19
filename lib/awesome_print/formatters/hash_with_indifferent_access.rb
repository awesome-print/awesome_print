module AwesomePrint
  module Formatters
    class HashWithIndifferentAccess < Formatter

      def call
        AwesomePrint::Formatters::Hash.new(formatter, object).call
      end
    end
  end
end
