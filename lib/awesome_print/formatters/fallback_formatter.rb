require_relative 'base_formatter'

# this handles some fallback logic to route things we don't know what they are

module AwesomePrint
  module Formatters
    class FallbackFormatter < BaseFormatter

      formatter_for :self

      def self.formattable?(object)
        true
      end

      def self.core?
        true
      end

      def format(object)
        if @options[:raw] && object.instance_variables.any?
          Formatters::ObjectFormatter.new(@inspector).format(object)
        elsif (hash = convert_to_hash(object))
          Formatters::HashFormatter.new(@inspector).format(hash)
        else
          Formatters::SimpleFormatter.new(@inspector).format(object.inspect.to_s)
        end
      end


      private

      # Utility methods.
      #------------------------------------------------------------------------------
      # FIXME: this could be super fixed.
      #
      def convert_to_hash(object)
        if !object.respond_to?(:to_hash)
          return nil
        end

        if object.method(:to_hash).arity != 0
          return nil
        end

        hash = object.to_hash
        if !hash.respond_to?(:keys) || !hash.respond_to?('[]')
          return nil
        end

        return hash
      end

    end
  end
end
