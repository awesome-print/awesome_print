require_relative 'simple_formatter'

module AwesomePrint
  module Formatters
    class RationalFormatter < SimpleFormatter

      formatter_for :rational

      def self.formattable?(object)
        object.is_a?(Rational)
      end

    end
  end
end
