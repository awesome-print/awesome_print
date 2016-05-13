module AwesomePrint
  module Formatters
    class HashFormatter

      attr_reader :hash, :inspector, :options, :indentation

      def initialize(hash, inspector)
        @hash = hash
        @inspector = inspector
        @options = inspector.options
        @indentation = @options[:indent].abs
      end

      def format
        return "{}" if h == {}

        keys = options[:sort_keys] ? h.keys.sort { |a, b| a.to_s <=> b.to_s } : h.keys
        data = keys.map do |key|
          plain_single_line do
            [ inspector.awesome(key), h[key] ]
          end
        end

        width = data.map { |key, | key.size }.max || 0
        width += indentation if options[:indent] > 0

        data = data.map do |key, value|
          indented do
            align(key, width) << colorize(" => ", :hash) << inspector.awesome(value)
          end
        end

        data = limited(data, width, :hash => true) if should_be_limited?
        if options[:multiline]
          "{\n" << data.join(",\n") << "\n#{outdent}}"
        else
          "{ #{data.join(', ')} }"
        end
      end
    end
  end
end
