module AwesomePrint
  module Formatters
    class Self < Base

      def call
        if options[:raw] && object.instance_variables.any?
          return AwesomePrint::Formatters::Object.new(formatter, object).call
        elsif hash = convert_to_hash(object)
          AwesomePrint::Formatters::Hash.new(formatter, hash).call
        else
          formatter.colorize(object.inspect.to_s, formatter.type)
        end
      end

      private

        def convert_to_hash(object)
          if ! object.respond_to?(:to_hash)
            return nil
          end
          if object.method(:to_hash).arity != 0
            return nil
          end

          hash = object.to_hash
          if ! hash.respond_to?(:keys) || ! hash.respond_to?('[]')
            return nil
          end

          return hash
        end
    end
  end
end
