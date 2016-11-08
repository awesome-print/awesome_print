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
        return '{}' if hash == {}

        keys = hash.keys
        keys = keys.sort { |a, b| a.to_s <=> b.to_s } if options[:sort_keys]
        data = keys.map do |key|
          plain_single_line do
            [ inspector.awesome(key), hash[key] ]
          end
        end

        width = data.map { |key, | key.size }.max || 0
        width += indentation if options[:indent] > 0

        data = data.map do |key, value|
          indented do
            if options[:ruby19_syntax] && symbol?(key)
              ruby19_syntax(key, value, width)
            else
              pre_ruby19_syntax(key, value, width)
            end
          end
        end

        data = limited(data, width, hash: true) if should_be_limited?
        if options[:multiline]
          "{\n" << data.join(",\n") << "\n#{outdent}}"
        else
          "{ #{data.join(', ')} }"
        end
      end

      private

      def symbol?(k)
        k[0] == ':'
      end

      def ruby19_syntax(k, v, width)
        k[0] = ''
        align(k, width - 1) << colorize(': ', :hash) << inspector.awesome(v)
      end

      def pre_ruby19_syntax(k, v, width)
        align(k, width) << colorize(' => ', :hash) << inspector.awesome(v)
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
