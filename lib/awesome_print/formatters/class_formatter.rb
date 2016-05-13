require_relative 'base_formatter'

module AwesomePrint
  module Formatters
    class ClassFormatter < BaseFormatter

      attr_reader :klass, :inspector, :options, :indentation

      def initialize(klass, inspector)
        @klass = klass
        @inspector = inspector
        @options = inspector.options
        @indentation = @options[:indent].abs
      end

      def format
        if superclass = klass.superclass # <-- Assign and test if nil.
          colorize("#{klass.inspect} < #{superclass}", :class)
        else
          colorize(klass.inspect, :class)
        end
      end
    end
  end
end
