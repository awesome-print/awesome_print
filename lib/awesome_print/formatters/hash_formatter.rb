require_relative 'base_formatter'

module AwesomePrint
  module Formatters
    class HashFormatter < BaseFormatter
      attr_reader :hash, :inspector, :options

      def initialize(hash, inspector, options = {})
        @hash      = hash
        @inspector = inspector
        @options   = inspector.options
        @options   = @options.merge(options) if !options.empty?
      end

      def format
        if hash.empty?
          empty_hash
        elsif options[:multiline]
          multiline_hash
        else
          simple_hash
        end
      end

      private

      def empty_hash
        colorize('{}', :hash_syntax)
      end

      def multiline_hash
        object_type = ''
        if options[:display_object_reference]
          object_type = colorize("#<Hash:#{ hash.object_id }> ", :object_reference)
        end

        [
          object_type,
          colorize('{', :hash_syntax),
          "\n",
          printable_hash.join(",\n"),
          "\n",
          outdent,
          colorize('}', :hash_syntax),
        ].join('')
      end

      def simple_hash
        object_type = ''
        if options[:display_object_reference]
          object_type = colorize("#<Hash:#{ hash.object_id }> ", :object_reference)
        end

        [
          object_type,
          colorize('{ ', :hash_syntax),
          printable_hash.join(', '),
          colorize(' }', :hash_syntax),
        ].join('')
      end

      def printable_hash
        data  = printable_keys
        width = left_width(data)

        data.map! do |key, fmtd_key, value|
          indented do
            if options[:ruby19_syntax] && key.is_a?(::Symbol)
              ruby19_syntax(key, fmtd_key, value, width)
            else
              pre_ruby19_syntax(key, fmtd_key, value, width)
            end
          end
        end

        should_be_limited? ? limited(data, width, hash: true) : data
      end

      def left_width(keys)
        result  = max_key_width(keys)
        result += indentation if options[:indent] > 0
        result
      end

      def max_key_width(keys)
        keys.map { |key, _value| key.to_s.size }.max || 0
      end

      def printable_keys
        keys = hash.keys

        if options[:sort_keys]
          keys = keys.sort { |a, b| a.to_s <=> b.to_s }
        end

        keys.map do |key|
          awesome_with_options(multiline: false, plain: false) do
            [key, inspector.awesome(key), hash[key]]
          end
        end
      end

      def ruby19_syntax(key, fmtd_key, value, width)
        fmtd_key_plain = uncolorize(fmtd_key)

        [
          smart_align(value_plain: fmtd_key_plain, value: fmtd_key, width: width - 1),
          colorize(': ', :hash_syntax),
          inspector.awesome(value),
        ].join('')
      end

      def pre_ruby19_syntax(key, fmtd_key, value, width)
        fmtd_key_plain = uncolorize(fmtd_key)

        [
          smart_align(value_plain: fmtd_key_plain, value: fmtd_key, width: width),
          colorize(' => ', :hash_syntax),
          inspector.awesome(value),
        ].join('')
      end

      def awesome_with_options(plain:, multiline:)
        saved_plain         = options[:plain]
        saved_multiline     = options[:multiline]
        options[:plain]     = plain
        options[:multiline] = multiline
        yield
      ensure
        options[:plain]     = saved_plain
        options[:multiline] = saved_multiline
      end

    end
  end
end
