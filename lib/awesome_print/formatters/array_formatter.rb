require_relative 'base_formatter'

module AwesomePrint
  module Formatters
    class ArrayFormatter < BaseFormatter
      attr_reader :array, :inspector, :options

      def initialize(array, inspector, options = {})
        @array     = array
        @inspector = inspector
        @options   = inspector.options
        @options   = @options.merge(options) if !options.empty?
      end

      def format
        if array.length.zero?
          colorize('[]', :array_syntax)
        elsif methods_array?
          methods_array
        else
          simple_array
        end
      end

      private

      def methods_array?
        array.instance_variable_defined?('@__awesome_methods__')
      end

      def simple_array
        if options[:multiline]
          multiline_array
        else
          object_type = ''
          if options[:display_object_reference]
            object_type = colorize("#<Array:#{ array.object_id }> ", :object_reference)
          end

          [
            object_type,
            colorize('[', :array_syntax),
            array.map { |item| inspector.awesome(item) }.join(', '),
            colorize(']', :array_syntax),
          ].join('')
        end
      end

      def multiline_array
        data = unless should_be_limited?
                 generate_printable_array
               else
                 limited(generate_printable_array, width(array))
               end

        object_type = ''
        if options[:display_object_reference]
          object_type = colorize("#<Array:#{ array.object_id }> ", :object_reference)
        end

        [
          object_type,
          colorize('[', :array_syntax),
          "\n",
          data.join(",\n"),
          "\n",
          outdent,
          colorize(']', :array_syntax),
        ].join('')
     end

      def generate_printable_array
        array.map.with_index do |item, index|
          array_prefix(index, width(array)).tap do |temp|
            indented { temp << inspector.awesome(item) }
          end
        end
      end

      def array_prefix(iteration, width)
        generic_prefix(iteration, width)
      end

      def methods_array
        array.map!(&:to_s).sort!

        data = generate_printable_tuples.join("\n")

        [
          colorize('[', :array_syntax),
          "\n",
          data,
          "\n",
          outdent,
          colorize(']', :array_syntax),
        ].join('')
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

        [
          colorize(item[0].rjust(name_width), :method),
          colorize(item[1].ljust(args_width), :args),
          ' ',
          colorize(item[2], :class)
        ].join
      end

      def tuples
        @tuples ||= array.map { |name| generate_tuple(name) }
      end

      def name_and_args_width
        name_and_args = tuples.transpose

        return name_and_args[0].map(&:size).max, name_and_args[1].map(&:size).max
      end

      def tuple_prefix(iteration, width)
        generic_prefix(iteration, width, ' ')
      end

      def generate_tuple(name)
        meth = case name
               when Symbol, String
                 find_method(name)
               end

        meth ? method_tuple(meth) : [name.to_s, '(?)', '?']
      end

      def find_method(name)
        object = array.instance_variable_get('@__awesome_methods__')

        meth = begin
          object.method(name)
        rescue NameError, ArgumentError
          nil
        end

        meth || begin
          object.instance_method(name)
        rescue NameError
          nil
        end
      end

      def generic_prefix(iteration, width, padding='')
        if options[:index]
          indent + colorize("[#{ iteration.to_s.rjust(width) }] ", :array_indices)
        else
          indent + padding
        end
      end

      def width(items)
        (items.size - 1).to_s.size
      end
    end
  end
end
