module AwesomePrint
  module Formatters
    class Set < Base

      def call
        AwesomePrint::Formatters::Array.new(formatter, object.to_a).call
      end
    end
  end
end
