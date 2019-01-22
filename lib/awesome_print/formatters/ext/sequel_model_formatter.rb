require_relative '../base_formatter'

module AwesomePrint
  module Formatters
    class SequelModelFormatter < BaseFormatter

      formatter_for :sequel_model

      def self.formattable?(object)
        defined?(::Sequel::Model) && object.is_a?(::Sequel::Model)
      end

      def format(object)
        data = object.values.sort_by { |key| key.to_s }.inject({}) do |hash, c|
          hash[c[0].to_sym] = c[1]
          hash
        end
        data = { errors: object.errors, values: data } if !object.errors.empty?
        hf = Formatters::HashFormatter.new(@inspector)

        "#{colorize(object.to_s, :sequel)} #{hf.format(data)}"
      end

    end
  end
end
