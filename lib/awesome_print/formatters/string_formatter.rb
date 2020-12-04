require_relative 'base_formatter'

module AwesomePrint
  module Formatters
    class StringFormatter < BaseFormatter

      attr_reader :object, :inspector, :options

      def initialize(object, inspector)
        @object    = object
        @inspector = inspector
        @options   = inspector.options
      end

      def format
        [colorize("'", :syntax), colorize(object, :string), colorize("'", :syntax)].join('')
      end

    end
  end
end
