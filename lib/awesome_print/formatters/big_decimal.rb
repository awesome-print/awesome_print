module AwesomePrint
  module Formatters
    class BigDecimal < Base

      def call
        formatter.colorize(object.to_s('F'), :bigdecimal)
      end
    end
  end
end

