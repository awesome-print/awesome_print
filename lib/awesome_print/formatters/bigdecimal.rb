module AwesomePrint
  module Formatters
    class Bigdecimal < Formatter

      def call
        formatter.colorize(object.to_s('F'), :bigdecimal)
      end
    end
  end
end

