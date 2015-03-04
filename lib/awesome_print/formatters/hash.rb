module AwesomePrint
  module Formatters
    class Hash

      def initialize(formatter, hash)
        @formatter = formatter
        @hash = hash
        @options = formatter.options
        @inspector = formatter.inspector
        @indentation = formatter.indentation
      end

      def call
        return "{}" if hash.empty?

        keys = options[:sort_keys] ? hash.keys.sort { |a, b| a.to_s <=> b.to_s } : hash.keys
        data = keys.map do |key|
          formatter.plain_single_line do
            [ inspector.awesome(key), hash[key] ]
          end
        end

        width = data.map { |key, | key.size }.max || 0
        width += indentation if options[:indent] > 0

        data = data.map do |key, value|
          formatter.indented do
            formatter.align(key, width) << formatter.colorize(" => ", :hash) << inspector.awesome(value)
          end
        end

        data = formatter.limited(data, width, :hash => true) if formatter.should_be_limited?
        if options[:multiline]
          "{\n" << data.join(",\n") << "\n#{formatter.outdent}}"
        else
          "{ #{data.join(', ')} }"
        end
      end

      private

        attr_reader :formatter, :hash, :indentation

        def options
          @options
        end

        def inspector
          @inspector
        end
    end
  end
end
