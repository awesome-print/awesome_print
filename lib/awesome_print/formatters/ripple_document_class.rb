module AwesomePrint
  module Formatters
    class RippleDocumentClass < Base

      def call
        return object.inspect if !defined?(::ActiveSupport::OrderedHash) || !object.respond_to?(:properties)

        "class #{object} < #{object.superclass} " << AwesomePrint::Formatters::Hash.new(formatter, columns).call
      end

      private

      def columns
        data = object.properties.inject(::ActiveSupport::OrderedHash.new) do |hash, (name, defn)|
          hash[name.to_sym] = defn.type.to_s.downcase.to_sym
          hash
        end
        data
      end
    end
  end
end
