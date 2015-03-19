module AwesomePrint
  module Formatters
    class MongoidClass < Formatter

      def call
        return object.inspect if !defined?(::ActiveSupport::OrderedHash) || !object.respond_to?(:fields)

        "class #{object} < #{object.superclass} " <<  AwesomePrint::Formatters::Hash.new(formatter, columns).call
      end

      private

        def columns
          object.fields.sort_by { |key| key }.inject(::ActiveSupport::OrderedHash.new) do |hash, c|
            hash[c[1].name.to_sym] = (c[1].type || "undefined").to_s.underscore.intern
            hash
          end
        end
    end
  end
end
