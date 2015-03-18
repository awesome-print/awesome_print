require 'awesome_print/formatters/enumerable'

module AwesomePrint
  module Formatters
    class Hash < Base
      include Enumerable

      def call
        return empty_format if object.empty?
        build_data
        if options[:multiline]
          multiline_format
        else
          inline_format
        end
      end

      private

        attr_reader :width, :data

        def empty_format
          '{}'
        end

        def keys
          options[:sort_keys] ? object.keys.sort { |a, b| a.to_s <=> b.to_s } : object.keys
        end

        def build_width
          @width = @data.map { |key, | key.size }.max || 0
          @width += indentation if options[:indent] > 0
        end

        def build_data
          @data = keys.map do |key|
            plain_single_line do
              [ inspector.awesome(key), object[key] ]
            end
          end

          build_width

          @data = @data.map do |key, value|
            formatter.indented do
              if options[:new_hash_syntax] && is_a_symbol?(key)
                new_hash_syntax_format(key, value)
              else
                old_hash_syntax_format(key, value)
              end
            end
          end

          @data = limited(@data, width, :hash => true) if should_be_limited?
        end

        def multiline_format
          "{\n" << data.join(",\n") << "\n#{formatter.outdent}}"
        end

        def inline_format
          "{ #{data.join(', ')} }"
        end

        def plain_single_line
          plain, multiline = options[:plain], options[:multiline]
          options[:plain], options[:multiline] = true, false
          yield
        ensure
          options[:plain], options[:multiline] = plain, multiline
        end

        def old_hash_syntax_format(key, value)
          formatter.align(key, width) << formatter.colorize(" => ", :hash) << inspector.awesome(value)
        end

        def new_hash_syntax_format(key, value)
          key[0] = ''
          formatter.align(key, width - 1) << formatter.colorize(": ", :hash) << inspector.awesome(value)
        end

        def is_a_symbol?(key)
          key[0] == ':'
        end
    end
  end
end
