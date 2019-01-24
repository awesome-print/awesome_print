require_relative '../base_formatter'

module AwesomePrint
  module Formatters
    class ActiveRecordInstanceFormatter < BaseFormatter

      formatter_for :active_record_instance

      def self.formattable?(object)
        defined?(::ActiveRecord) && object.is_a?(::ActiveRecord::Base)
      end

      # Format ActiveRecord instance object.
      #
      # NOTE: by default only instance attributes (i.e. columns) are shown. To format
      # ActiveRecord instance as regular object showing its instance variables and
      # accessors use :raw => true option:
      #
      # ap record, :raw => true
      #
      #------------------------------------------------------------------------------
      def format(object)
        if @options[:raw]
          return Formatters::ObjectFormatter.new(@inspector).format(object)
        end

        if !defined?(::ActiveSupport::OrderedHash)
          return Formatters::SimpleFormatter.new(@inspector).format(object.inspect)
        end

        if object.class.column_names != object.attributes.keys
          data = object.attributes
        else
          data = object.class.column_names.inject(::ActiveSupport::OrderedHash.new) do |hash, name|
            if object.has_attribute?(name) || object.new_record?
              value = object.respond_to?(name) ? object.send(name) : object.read_attribute(name)
              hash[name.to_sym] = value
            end
            hash
          end
        end

        "#{object} " << Formatters::HashFormatter.new(@inspector).format(data)
      end

    end
  end
end
