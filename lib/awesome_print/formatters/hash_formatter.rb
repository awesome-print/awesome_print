require_relative 'base_formatter'

module AwesomePrint
  module Formatters
    class HashFormatter < BaseFormatter

      attr_reader :hash, :inspector, :options

      def initialize(hash, inspector)
        @hash = hash
        @inspector = inspector
        @options = inspector.options
      end

      def format
        case
        when hash.empty?
          empty_hash
        when multiline_hash?
          multiline_hash
        else
          simple_hash
        end
      end

      private

      def empty_hash
        "{}"
      end

      def multiline_hash?
        options[:multiline]
      end

      def multiline_hash
        "{\n" << printable_hash.join(",\n") << "\n#{outdent}}"
      end

      def simple_hash
        "{ #{printable_hash.join(', ')} }"
      end

      def printable_hash
        data = printable_keys
        width = left_width(data)

        data.map! do |key, value|
          indented do
            if options[:ruby19_syntax] && symbol?(key)
              ruby19_syntax(key, value, width)
            else
              pre_ruby19_syntax(key, value, width)
            end
          end
        end

        should_be_limited? ? limited(data, width, hash: true) : data
      end

      def left_width(keys)
        options[:indent] > 0 ? indentation + max_key_width(keys) : max_key_width(keys)
      end

      def max_key_width(keys)
        keys.map { |key, | key.size }.max || 0
      end

      def printable_keys
        keys = hash.keys
        
        keys.sort! { |a, b| a.to_s <=> b.to_s } if options[:sort_keys]

        keys.map! do |key|
          plain_single_line do
            [ inspector.awesome(key), hash[key] ]
          end
        end
      end

      def symbol?(k)
        k[0] == ':'
      end

      def ruby19_syntax(k, v, width)
        k[0] = ''
        align(k, width - 1) << colorize(": ", :hash) << inspector.awesome(v)
      end

      def pre_ruby19_syntax(k, v, width)
        align(k, width) << colorize(" => ", :hash) << inspector.awesome(v)
      end

      def plain_single_line
        plain, multiline = options[:plain], options[:multiline]
        options[:plain], options[:multiline] = true, false
        yield
      ensure
        options[:plain], options[:multiline] = plain, multiline
      end
    end
  end
end
