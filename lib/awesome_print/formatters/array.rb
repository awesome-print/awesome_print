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
          methods_array(object)
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

        # Format object.methods array.
        #------------------------------------------------------------------------------
        def methods_array(a)
          a.sort! { |x, y| x.to_s <=> y.to_s }                  # Can't simply a.sort! because of o.methods << [ :blah ]
          object = a.instance_variable_get('@__awesome_methods__')
          tuples = a.map do |name|
            if name.is_a?(Symbol) || name.is_a?(String)         # Ignore garbage, ex. 42.methods << [ :blah ]
              tuple = if object.respond_to?(name, true)         # Is this a regular method?
                the_method = object.method(name) rescue nil     # Avoid potential ArgumentError if object#method is overridden.
                if the_method && the_method.respond_to?(:arity) # Is this original object#method?
                  formatter.method_tuple(the_method)                      # Yes, we are good.
                end
              elsif object.respond_to?(:instance_method)              # Is this an unbound method?
                formatter.method_tuple(object.instance_method(name)) rescue nil # Rescue to avoid NameError when the method is not
              end                                                     # available (ex. File.lchmod on Ubuntu 12).
            end
            tuple || [ name.to_s, '(?)', '?' ]                  # Return WTF default if all the above fails.
          end

          width = (tuples.size - 1).to_s.size
          name_width = tuples.map { |item| item[0].size }.max || 0
          args_width = tuples.map { |item| item[1].size }.max || 0

          data = tuples.inject([]) do |arr, item|
            index = formatter.indent
            index << "[#{arr.size.to_s.rjust(width)}]" if options[:index]
            formatter.indented do
              arr << "#{index} #{formatter.colorize(item[0].rjust(name_width), :method)}#{formatter.colorize(item[1].ljust(args_width), :args)} #{formatter.colorize(item[2], :class)}"
            end
          end

          "[\n" << data.join("\n") << "\n#{formatter.outdent}]"
        end
    end
  end
end
