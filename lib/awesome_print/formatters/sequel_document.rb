module AwesomePrint
  module Formatters
    class SequelDocument < Base

      def call
        data = object.values.sort_by { |key| key.to_s }.inject({}) do |hash, c|
          hash[c[0].to_sym] = c[1]
          hash
        end
        if !object.errors.empty?
          data = {:errors => object.errors, :values => data}
        end
        "#{object} #{AwesomePrint::Formatters::Hash.new(formatter, data).call}"
      end
    end
  end
end
