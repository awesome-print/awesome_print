module AwesomePrint
  module Formatters
    class Array

      def initialize(formatter, array)
        @formatter = formatter
        @array = array
        @options = formatter.options
        @inspector = formatter.inspector
      end

      def call
        return empty_format if array.empty?

        if array.instance_variable_defined?('@__awesome_methods__')
          methods_format
        elsif options[:multiline]
          multiline_format
        else
          inline_format
        end
      end

      private

        attr_reader :formatter, :array

        def options
          @options
        end

        def inspector
          @inspector
        end

        def empty_format
          '[]'
        end

        def methods_format
          formatter.methods_array(array)
        end

        def inline_format
          "[ " << array.map{ |item| inspector.awesome(item) }.join(", ") << " ]"
        end

        def multiline_format
          width = (array.size - 1).to_s.size

          data = array.inject([]) do |arr, item|
            index = formatter.indent
            index << formatter.colorize("[#{arr.size.to_s.rjust(width)}] ", :array) if options[:index]
            formatter.indented do
              arr << (index << inspector.awesome(item))
            end
          end

          data = formatter.limited(data, width) if formatter.should_be_limited?
          "[\n" << data.join(",\n") << "\n#{formatter.outdent}]"
        end
    end
  end
end
