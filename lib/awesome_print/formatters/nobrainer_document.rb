module AwesomePrint
  module Formatters
    class NobrainerDocument < Base

      def call
        "#{object} #{AwesomePrint::Formatters::Hash.new(formatter, columns).call}"
      end

      private

        def columns
          data = object.inspectable_attributes.symbolize_keys
          if object.errors.present?
            data = {:errors => object.errors, :attributes => data}
          end
          data
        end
    end
  end
end
