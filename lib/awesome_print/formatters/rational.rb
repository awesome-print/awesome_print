module AwesomePrint
  module Formatters
    class Rational < Base

      def call
        formatter.colorize(object.to_s, :rational)
      end
    end
  end
end

