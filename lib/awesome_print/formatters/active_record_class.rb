module AwesomePrint
  module Formatters
    class ActiveRecordClass < Base

      def call
        return object.inspect if not_a_active_record_class?
        return class_format if object_is_abstract_class?

        "class #{object} < #{object.superclass} " << AwesomePrint::Formatters::Hash.new(formatter, columns).call
      end

      private

        def class_format
          AwesomePrint::Formatters::Class.new(formatter, object).call
        end

        def object_is_abstract_class?
          object.respond_to?(:abstract_class?) && object.abstract_class?
        end

        def not_a_active_record_class?
          !defined?(::ActiveSupport::OrderedHash) || !object.respond_to?(:columns) || object.to_s == "ActiveRecord::Base"
        end

        def columns
          object.columns.inject(::ActiveSupport::OrderedHash.new) do |hash, c|
            hash[c.name.to_sym] = c.type
            hash
          end
        end
    end
  end
end
