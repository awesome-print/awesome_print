require_relative 'base_formatter'

module AwesomePrint
  module Formatters
    class MethodFormatter < BaseFormatter

      attr_reader :method, :inspector, :options, :indentation

      def initialize(method, inspector)
        @method = method
        @inspector = inspector
        @options = inspector.options
        @indentation = @options[:indent].abs
      end

      def format
        name, args, owner = method_tuple(method)

        "#{colorize(owner, :class)}##{colorize(name, :method)}#{colorize(args, :args)}"
      end
    end
  end
end
