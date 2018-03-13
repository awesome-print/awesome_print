require_relative 'base_formatter'

module AwesomePrint
  module Formatters
    class ArrayFormatter < BaseFormatter

      def array
        @object
      end

      def format
        if array.empty?
          '[]'
        elsif methods_array?
          methods_array
        else
          simple_array
        end
      end

      private

      def methods_array?
        array.instance_variable_defined?(:@__awesome_methods__)
      end

      def simple_array
        if options[:multiline]
          multiline_array
        else
          '[ ' << array.map { |item| inspector.awesome(item) }.join(', ') << ' ]'
        end
      end

      def multiline_array
        data = if should_be_limited?
                 generate_limited_printable_array
               else
                 generate_printable_array
               end

        %Q([\n#{data.join(",\n")}\n#{outdent}])
      end

      def generate_printable_array
        array_width = width(array) # cache

        array.map.with_index do |item, index|
          array_prefix(index, array_width).tap do |temp|
            indented { temp << inspector.awesome(item) }
          end
        end
      end

      # Avoids colorizing a possibly huge array and THEN only limitting it.
      # This should be much faster.
      def generate_limited_printable_array
        limit = get_limit_size
        return generate_printable_array if array.length <= limit

        # cache
        array_width = width(array)
        inspector = inspector()

        # Calculate how many elements to be displayed above and below the separator.
        nhead = limit / 2
        ntail = nhead - (limit - 1) % 2

        head = array.first(nhead).map.with_index do |item, index|
          array_prefix(index, array_width).tap do |temp|
            indented { temp << inspector.awesome(item) }
          end
        end

        separator = "#{indent}[#{nhead.to_s.rjust(array_width)}] .. [#{array.length - ntail - 1}]"

        tail = array.last(ntail).map.with_index(array.length - ntail) do |item, index|
          array_prefix(index, array_width).tap do |temp|
            indented { temp << inspector.awesome(item) }
          end
        end

        [ *head, separator, *tail ]
      end

      def array_prefix(iteration, width)
        generic_prefix(iteration, width)
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
          indent + colorize("[#{iteration.to_s.rjust(width)}] ", :array)
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
