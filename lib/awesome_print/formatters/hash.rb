module AwesomePrint
  module Formatters
    class Hash < Base

      def call
        return "{}" if object.empty?

        keys = options[:sort_keys] ? object.keys.sort { |a, b| a.to_s <=> b.to_s } : object.keys
        data = keys.map do |key|
          formatter.plain_single_line do
            [ inspector.awesome(key), object[key] ]
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
    end
  end
end
