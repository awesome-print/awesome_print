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
        if hash.empty?
          empty_hash
        elsif multiline_hash?
          multiline_hash
        else
          simple_hash
        end
      end

      private

      def empty_hash
        '{}'
      end

      def multiline_hash?
        options[:multiline]
      end

      def multiline_hash
        ["{\n", printable_hash.join(",\n"), "\n#{outdent}}"].join
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
        result = max_key_width(keys)
        result += indentation if options[:indent] > 0
        result
      end

      def max_key_width(keys)
        keys.map { |key, _value| key.size }.max || 0
      end

      def printable_keys
        keys = hash.keys

        keys.sort! { |a, b| a.to_s <=> b.to_s } if options[:sort_keys]

        keys.map! do |key|
          plain_single_line do
            [String.new(inspector.awesome(key)), hash[key]]
          end
        end
      end

      def symbol?(key)
        key[0] == ':'
      end

      def ruby19_syntax(key, value, width)
        key[0] = ''
        align(key, width - 1) << colorize(': ', :hash) << inspector.awesome(value)
      end

      def pre_ruby19_syntax(key, value, width)
        align(key, width) << colorize(' => ', :hash) << inspector.awesome(value)
      end

      def plain_single_line
        plain = options[:plain]
        multiline = options[:multiline]
        options[:plain] = true
        options[:multiline] = false
        yield
      ensure
        options[:plain] = plain
        options[:multiline] = multiline
      end
    end
  end
end
