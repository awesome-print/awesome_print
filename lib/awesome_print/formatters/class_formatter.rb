require_relative 'base_formatter'

module AwesomePrint
  module Formatters
    class ClassFormatter < BaseFormatter

      def klass
        @object
      end

      def format
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
