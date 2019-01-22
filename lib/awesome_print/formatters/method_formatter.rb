require_relative 'base_formatter'

module AwesomePrint
  module Formatters
    class MethodFormatter < BaseFormatter

      formatter_for :method

      def self.formattable?(object)
        puts "formattable? for METHOD..."
        true
      end

      def format(method)
        name, args, owner = method_tuple(method)

        "#{colorize(owner, :class)}##{colorize(name, :method)}#{colorize(args, :args)}"
      end
    end
  end
end
