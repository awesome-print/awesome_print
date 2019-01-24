require_relative 'simple_formatter'

module AwesomePrint
  module Formatters
    class StringFormatter < SimpleFormatter

      formatter_for :string

      def format(object)
        colorize("\"#{object.to_s}\"", self.class.formatted_object_type)
      end
    end
  end
end
