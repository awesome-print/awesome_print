require_relative '../base_formatter'

module AwesomePrint
  module Formatters
    class MongoidDocument < BaseFormatter

      formatter_for :mongoid_document

      def self.formattable?(object)
        defined?(::Mongoid::Document) &&
          (object.class.ancestors.include?(::Mongoid::Document) ||
           (object.respond_to?(:ancestors) && object.ancestors.include?(::Mongoid::Document)))
      end

      def format(object)
        unless defined?(::ActiveSupport::OrderedHash)
          return Formatters::SimpleFormatter.new(@inspector).format(object.inspect)
        end

        if object.is_a?(Class)
          puts "[MGD] formatting #{object} as class..." if AwesomePrint.debug
          # mongoid class
          format_as_class(object)
        else
          puts "[MGD] formatting #{object} as instance..." if AwesomePrint.debug
          format_as_instance(object)
        end
      end

      private

      def format_as_class(object)
        data = object.fields.sort_by { |key| key }.inject(::ActiveSupport::OrderedHash.new) do |hash, c|
          hash[c[1].name.to_sym] = (c[1].type || 'undefined').to_s.underscore.to_sym
          hash
        end

        [
          "class #{colorize(object.to_s, :class)}",
          "< #{colorize(object.superclass.to_s, :class)}",
          Formatters::HashFormatter.new(@inspector).format(data)
        ].join(' ')
      end

      def format_as_instance(object)
        data = (object.attributes || {}).sort_by { |key| key }.inject(::ActiveSupport::OrderedHash.new) do |hash, c|
          hash[c[0].to_sym] = c[1]
          hash
        end

        data = { errors: object.errors, attributes: data } if !object.errors.empty?

        "#{object} #{Formatters::HashFormatter.new(@inspector).format(data)}"
      end

    end
  end
end

