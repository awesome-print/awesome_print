require_relative '../base_formatter'

module AwesomePrint
  module Formatters
    class ActiveRecordAttributesetFormatter < BaseFormatter

      formatter_for :active_record_attributeset

      def self.core?
        false
      end

      def self.formattable?(object)
        defined?(::ActiveRecord) &&
          defined?(::ActiveRecord::AttributeSet) &&
          object.is_a?(ActiveRecord::AttributeSet)
      end

      def format(object)
        # simple formatter for now
        Formatters::ObjectFormatter.new(@inspector).format(object)
      end


    end
  end
end
