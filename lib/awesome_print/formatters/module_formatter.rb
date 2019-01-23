require_relative 'base_formatter'

module AwesomePrint
  module Formatters
    class ModuleFormatter < BaseFormatter

      formatter_for :module

      def self.formattable?(object)
        object.is_a?(Module)
      end

      def format(object)
        colorize(object.inspect, :module)
      end
    end
  end
end
