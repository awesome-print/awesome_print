module AwesomePrint
  module Formatters
    class ActiveRecordInstance < Formatter

      # Format ActiveRecord instance object.
      #
      # NOTE: by default only instance attributes (i.e. columns) are shown. To format
      # ActiveRecord instance as regular object showing its instance variables and
      # accessors use :raw => true option:
      #
      # ap record, :raw => true
      #
      #------------------------------------------------------------------------------
      def call
        return object.inspect if !defined?(::ActiveSupport::OrderedHash)
        return raw_format if options[:raw]

        "#{object} " << AwesomePrint::Formatters::Hash.new(formatter, columns).call
      end

      private

        def raw_format
          AwesomePrint::Formatters::Object.new(formatter, object).call
        end

        def columns
          object.class.column_names.inject(::ActiveSupport::OrderedHash.new) do |hash, name|
            if object.has_attribute?(name) || object.new_record?
              value = object.respond_to?(name) ? object.send(name) : object.read_attribute(name)
              hash[name.to_sym] = value
            end
            hash
          end
        end
    end
  end
end
