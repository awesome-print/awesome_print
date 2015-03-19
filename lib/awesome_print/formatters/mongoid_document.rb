module AwesomePrint
  module Formatters
    class MongoidDocument < Formatter

      def call
        return object.inspect if !defined?(::ActiveSupport::OrderedHash)
        "#{object} #{AwesomePrint::Formatters::Hash.new(formatter, columns).call}"
      end

      private

      def columns
        data = (object.attributes || {}).sort_by { |key| key }.inject(::ActiveSupport::OrderedHash.new) do |hash, c|
          hash[c[0].to_sym] = c[1]
          hash
        end
        if !object.errors.empty?
          data = {:errors => object.errors, :attributes => data}
        end
        data
      end
    end
  end
end
