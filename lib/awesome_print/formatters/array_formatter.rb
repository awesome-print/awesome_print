module AwesomePrint
  module Formatters
    class ArrayFormatter

      attr_reader :array, :inspector, :options, :indentation

      def initialize(array, inspector)
        @array = array
        @inspector = inspector
        @options = inspector.options
        @indentation = @options[:indent].abs
      end

      def format
        return "[]" if array == []

        if array.instance_variable_defined?('@__awesome_methods__')
          methods_array(array)
        elsif options[:multiline]
          width = (array.size - 1).to_s.size

          data = array.inject([]) do |arr, item|
            index = indent
            index << colorize("[#{arr.size.to_s.rjust(width)}] ", :array) if options[:index]
            indented do
              arr << (index << inspector.awesome(item))
            end
          end

          data = limited(data, width) if should_be_limited?
          "[\n" << data.join(",\n") << "\n#{outdent}]"
        else
          "[ " << array.map{ |item| inspector.awesome(item) }.join(", ") << " ]"
        end
      end
    end
  end
end
