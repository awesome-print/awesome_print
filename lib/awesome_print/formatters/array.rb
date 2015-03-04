module AwesomePrint
  module Formatters
    class Array < Base

      def call
        return empty_format if object.empty?

        if object.instance_variable_defined?('@__awesome_methods__')
          methods_format
        elsif options[:multiline]
          multiline_format
        else
          inline_format
        end
      end

      private

        def empty_format
          '[]'
        end

        def methods_format
          formatter.methods_array(object)
        end

        def inline_format
          "[ " << object.map{ |item| inspector.awesome(item) }.join(", ") << " ]"
        end

        def multiline_format
          width = (object.size - 1).to_s.size

          data = object.inject([]) do |arr, item|
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
