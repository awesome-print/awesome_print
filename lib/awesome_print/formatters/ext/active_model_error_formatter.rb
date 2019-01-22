require_relative '../base_formatter'

module AwesomePrint
  module Formatters
    class ActiveModelErrorFormatter < BaseFormatter

      formatter_for :active_model_error

      def self.formattable?(object)
        defined?(::ActiveModel) && object.is_a?(::ActiveModel::Errors)
      end

      def format(object)
        if @options[:raw]
          return Formatters::ObjectFormatter.new(@inspector).format(object)
        end

        if !defined?(::ActiveSupport::OrderedHash)
          return Formatters::SimpleFormatter.new(@inspector).format(object.inspect)
        end

        object_dump = object.marshal_dump.first

        if object_dump.class.column_names != object_dump.attributes.keys
          data = object_dump.attributes
        else
          data = object_dump.class.column_names.inject(::ActiveSupport::OrderedHash.new) do |hash, name|

            if object_dump.has_attribute?(name) || object_dump.new_record?
              value = object_dump.respond_to?(name) ? object_dump.send(name) : object_dump.read_attribute(name)
              hash[name.to_sym] = value
            end
            hash
          end
        end

        data.merge!({details: object.details, messages: object.messages})

        "#{object} " << Formatters::HashFormatter.new(@inspector).format(data)
      end

    end
  end
end
