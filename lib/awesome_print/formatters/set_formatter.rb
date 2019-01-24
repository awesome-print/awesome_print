require_relative 'base_formatter'

module AwesomePrint
  module Formatters
    class SetFormatter < BaseFormatter

      formatter_for :set

      def self.formattable?(object)
        object.kind_of?(Set)
      end

      def format(object)
        Formatters::ArrayFormatter.new(@inspector).format(object.to_a)
      end

    end
  end
end
