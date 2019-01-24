require_relative '../array_formatter'

module AwesomePrint
  module Formatters
    class ActiveRecordRelationFormatter < ArrayFormatter

      formatter_for :active_record_relation

      def self.core?
        false
      end

      def self.formattable?(object)
        defined?(::ActiveRecord) && object.class.ancestors.include?(::ActiveRecord::Relation)
      end

    end
  end
end
