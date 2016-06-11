require_relative 'base_formatter'

module AwesomePrint
  module Formatters
    class ArrayFormatter < BaseFormatter

      attr_reader :array, :inspector, :options

      def initialize(array, inspector)
        @array = array
        @inspector = inspector
        @options = inspector.options
      end

      def format
        case
        when array.empty?
          empty_array
        when awesome_array?
          methods_array
        when multiline_array?
          multiline_array
        else
          simple_array
        end
      end

      private

      def awesome_array?
        array.instance_variable_defined?('@__awesome_methods__')
      end

      def multiline_array?
        options[:multiline]
      end

      def empty_array
        "[]"
      end

      def simple_array
        "[ " << array.map{ |item| inspector.awesome(item) }.join(", ") << " ]"
      end

      def multiline_array
        data = generate_printable_array
        data = limited(data, width(array)) if should_be_limited?
        data = data.join(",\n")

        "[\n#{data}\n#{outdent}]"
      end

      def generate_printable_array
        array.map.with_index do |item, index|
          array_prefix(index, width(array)).tap do |temp|
            indented { temp << inspector.awesome(item) }
          end
        end
      end

      def array_prefix(iteration, width)
        if options[:index]
          indent + colorize("[#{iteration.to_s.rjust(width)}] ", :array)
        else
          indent
        end
      end

      def methods_array
        array.map!(&:to_s).sort!

        data = generate_printable_tuples.join("\n")

        "[\n#{data}\n#{outdent}]"
      end

      def generate_printable_tuples
        tuples.map.with_index do |item, index|
          tuple_prefix(index, width(tuples)).tap do |temp|
            indented { temp << tuple_template(item) }
          end
        end
      end

      def tuple_template(item)
        name_width, args_width = name_and_args_width

        str = ""
        str += "#{colorize(item[0].rjust(name_width), :method)}"
        str += "#{colorize(item[1].ljust(args_width), :args)} "
        str += "#{colorize(item[2], :class)}"
      end

      def tuples
        @tuples ||= array.map { |name| generate_tuple(name) }
      end

      def name_and_args_width
        name_width, args_width = 0, 0

        tuples.each do |item|
          name_width = [name_width, item[0].size].max
          args_width = [args_width, item[1].size].max
        end

        return name_width, args_width
      end

      def tuple_prefix(iteration, width)
        if options[:index]
          indent + colorize("[#{iteration.to_s.rjust(width)}] ", :array)
        else
          indent + " "
        end
      end

      def generate_tuple(name)
        meth = case name
        when Symbol, String
          find_method(name)
        else
          nil
        end

        meth ? method_tuple(meth) : [ name.to_s, '(?)', '?' ]
      end

      def find_method(name)
        object = array.instance_variable_get('@__awesome_methods__')

        meth = begin
          object.method(name)
        rescue NameError, ArgumentError
          nil
        end

        meth ||= begin
          object.instance_method(name)
        rescue NameError
          nil
        end
      end

      def width(items)
        (items.size - 1).to_s.size
      end
    end
  end
end
