module AwesomePrint
  module Formatters
    class Rational < Formatter

      def call
        formatter.colorize(object.to_s, :rational)
      end
    end
  end
end
