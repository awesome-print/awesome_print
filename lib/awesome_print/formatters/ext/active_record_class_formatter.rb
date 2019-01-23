require_relative '../base_formatter'

module AwesomePrint
  module Formatters
    class ActiveRecordClassFormatter < BaseFormatter

      formatter_for :activerecord_base_class

      def self.formattable?(object)
        defined?(::ActiveRecord) && object.is_a?(Class) &&
          (object.superclass == ::ActiveRecord::Base ||
           object.ancestors.include?(::ActiveRecord::Base))
      end

      def format(object)
        if @options[:raw] || object.to_s == "ActiveRecord::Base"
          return Formatters::ObjectFormatter.new(@inspector).format(object)
        end

        if object.respond_to?(:abstract_class?) && object.abstract_class?
          return Formatters::ClassFormatter.new(@inspector).format(object)
        end

        if !defined?(::ActiveSupport::OrderedHash) || !object.respond_to?(:columns)
          return Formatters::SimpleFormatter.new(@inspector).format(object.inspect)
        end

        data = object.columns.inject(::ActiveSupport::OrderedHash.new) do |hash, c|
          hash[c.name.to_sym] = c.type
          hash
        end

        [
          "class #{colorize(object.to_s, :class)}",
          "< #{colorize(object.superclass.to_s, :class)}",
          Formatters::HashFormatter.new(@inspector).format(data)
        ].join(' ')

      end

    end
  end
end
