require_relative 'base_formatter'

module AwesomePrint
  module Formatters
    class ClassFormatter < BaseFormatter

      formatter_for :class

      def self.formattable?(object)
        object.is_a?(Class)
      end

      def format(klass)
        superclass = klass.superclass

        if superclass
          colorize("#{klass.inspect} < #{superclass}", :class)
        else
          colorize(klass.inspect, :class)
        end
      end
    end
  end
end
