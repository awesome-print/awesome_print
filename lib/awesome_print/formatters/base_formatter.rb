require_relative '../colorize'

module AwesomePrint
  module Formatters
    class BaseFormatter
      include Colorize

      DEFAULT_LIMIT_SIZE = 7

      # To support limited output, for example:
      #
      # ap ('a'..'z').to_a, :limit => 3
      # [
      #     [ 0] "a",
      #     [ 1] .. [24],
      #     [25] "z"
      # ]
      #
      # ap (1..100).to_a, :limit => true # Default limit is 7.
      # [
      #     [ 0] 1,
      #     [ 1] 2,
      #     [ 2] 3,
      #     [ 3] .. [96],
      #     [97] 98,
      #     [98] 99,
      #     [99] 100
      # ]
      #------------------------------------------------------------------------------
      def should_be_limited?
        options[:limit] or (options[:limit].is_a?(Integer) and options[:limit] > 0)
      end

      def get_limit_size
        case options[:limit]
        when true
          DEFAULT_LIMIT_SIZE
        else
          options[:limit]
        end
      end

      def limited(data, width, is_hash = false)
        limit = get_limit_size
        if data.length <= limit
          data
        else
          # Calculate how many elements to be displayed above and below the separator.
          head = limit / 2
          tail = head - (limit - 1) % 2

          # Add the proper elements to the temp array and format the separator.
          temp = data[0, head] + [nil] + data[-tail, tail]

          temp[head] = if is_hash
                         "#{indent}#{data[head].strip} .. #{data[data.length - tail - 1].strip}"
                       else
                         "#{indent}[#{head.to_s.rjust(width)}] .. [#{data.length - tail - 1}]"
                       end

          temp
        end
      end


      def method_tuple(method)
        if method.respond_to?(:parameters) # Ruby 1.9.2+
          # See http://readruby.chengguangnan.com/methods#method-objects-parameters
          # (mirror: http://archive.is/XguCA#selection-3381.1-3381.11)
          args = method.parameters.inject([]) do |arr, (type, name)|
            name ||= (type == :block ? 'block' : "arg#{arr.size + 1}")
            arr << case type
              when :req        then name.to_s
              when :opt, :rest then "*#{name}"
              when :block      then "&#{name}"
              else '?'
            end
          end
        else # See http://ruby-doc.org/core/classes/Method.html#M001902
          args = (1..method.arity.abs).map { |i| "arg#{i}" }
          args[-1] = "*#{args[-1]}" if method.arity < 0
        end

        # method.to_s formats to handle:
        #
        # #<Method: Fixnum#zero?>
        # #<Method: Fixnum(Integer)#years>
        # #<Method: User(#<Module:0x00000103207c00>)#_username>
        # #<Method: User(id: integer, username: string).table_name>
        # #<Method: User(id: integer, username: string)(ActiveRecord::Base).current>
        # #<UnboundMethod: Hello#world>
        #
        if method.to_s =~ /(Unbound)*Method: (.*?)[#\.]/
          unbound = $1 && '(unbound)'
          klass = $2
          if klass && klass =~ /(\(\w+:\s.*?\))/  # Is this ActiveRecord-style class?
            klass.sub!($1, '')                    # Yes, strip the fields leaving class name only.
          end
          owner = "#{klass}#{unbound}".gsub('(', ' (')
        end

        [method.name.to_s, "(#{args.join(', ')})", owner.to_s]
      end

      #
      # Indentation related methods
      #-----------------------------------------
      def indentation
        inspector.current_indentation
      end

      def indented(&block)
        inspector.increase_indentation(&block)
      end

      def indent
        ' ' * indentation
      end

      def outdent
        ' ' * (indentation - options[:indent].abs)
      end

      def align(value, width)
        if options[:multiline]
          if options[:indent] > 0
            value.rjust(width)
          elsif options[:indent] == 0
            indent + value.ljust(width)
          else
            indent[0, indentation + options[:indent]] + value.ljust(width)
          end
        else
          value
        end
      end

    end
  end
end
