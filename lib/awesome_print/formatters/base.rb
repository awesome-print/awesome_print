module AwesomePrint
  module Formatters
    class Base

      def initialize(formatter, object)
        @formatter = formatter
        @object = object
        @options = formatter.options
        @inspector = formatter.inspector
        @indentation = formatter.indentation
      end

      private

        attr_reader :formatter, :object, :indentation

        def options
          @options
        end

        def inspector
          @inspector
        end
    end
  end
end
