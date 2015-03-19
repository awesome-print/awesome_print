module AwesomePrint
  module Formatters
    class NobrainerClass < Formatter

      def call
        "class #{object} < #{object.superclass} " << AwesomePrint::Formatters::Hash.new(formatter, columns).call
      end

      private

        def columns
          ::Hash[object.fields.map do |field, opt|
            [field, (opt[:type] || ::Object).to_s.underscore.to_sym]
          end]
        end
    end
  end
end
