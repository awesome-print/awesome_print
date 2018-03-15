require_relative 'base_formatter'

module AwesomePrint
  module Formatters
    class SimpleFormatter < BaseFormatter

      attr_accessor :type

      def string
        @object
      end


      def initialize(string, type, inspector)
        super(string, inspector)
        @type = type
      end

      def format
        colorize(string, type)
      end
    end
  end
end
