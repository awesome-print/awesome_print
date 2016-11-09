require_relative 'base_formatter'

module AwesomePrint
  module Formatters
    class ClassFormatter < BaseFormatter

      attr_reader :klass, :inspector, :options

      def initialize(klass, inspector)
        @klass = klass
        @inspector = inspector
        @options = inspector.options
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
