module AwesomePrint
  module Formatters
    module Enumerable

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
        @options[:limit] == true or (@options[:limit].is_a?(Fixnum) and @options[:limit] > 0)
      end

      # Mover para um modulo e incluir apenas no array e hash formatters
      # fazer o mesmo com o should_be_limited?
      def limited(data, width, is_hash = false)
        limit = get_limit_size
        if data.length <= limit
          data
        else
          # Calculate how many elements to be displayed above and below the separator.
          head = limit / 2
          tail = head - (limit - 1) % 2

          # Add the proper elements to the temp array and format the separator.
          temp = data[0, head] + [ nil ] + data[-tail, tail]

          if is_hash
            temp[head] = "#{formatter.indent}#{data[head].strip} .. #{data[data.length - tail - 1].strip}"
          else
            temp[head] = "#{formatter.indent}[#{head.to_s.rjust(width)}] .. [#{data.length - tail - 1}]"
          end

          temp
        end
      end

      def get_limit_size
        options[:limit] == true ? AwesomePrint::Formatter::DEFAULT_LIMIT_SIZE : options[:limit]
      end
    end
  end
end
