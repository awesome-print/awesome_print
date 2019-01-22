require_relative 'base_formatter'

module AwesomePrint
  module Formatters
    class OpenStruct < BaseFormatter

      formatter_for :openstruct

      def self.formattable?(object)
        defined?(::OpenStruct) && object.is_a?(::OpenStruct)
      end

      def format(object)
        "#{object.class} #{HashFormatter.new(inspector).format(object.marshal_dump)}"
      end

    end
  end
end
