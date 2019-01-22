require_relative 'base_formatter'

module AwesomePrint
  module Formatters
    class MethodFormatter < BaseFormatter

      formatter_for :method

      def self.core?
        true
      end

      def self.formattable?(object)
        object.is_a?(Method)
      end

      def format(method)
        name, args, owner = method_tuple(method)

        "#{colorize(owner, :class)}##{colorize(name, :method)}#{colorize(args, :args)}"
      end
    end
  end
end
