module AwesomePrint
  module Limiter

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


  end
end
