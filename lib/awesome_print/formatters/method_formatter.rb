require_relative 'base_formatter'

module AwesomePrint
  module Formatters
    class MethodFormatter < BaseFormatter

      def method
        @object
      end

      def format
        name, args, owner = method_tuple(method)

        "#{colorize(owner, :class)}##{colorize(name, :method)}#{colorize(args, :args)}"
      end
    end
  end
end
