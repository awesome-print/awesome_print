require_relative '../base_formatter'

module AwesomePrint
  module Formatters
    class SequelDatasetFormatter < BaseFormatter

      formatter_for :sequel_dataset

      def self.formattable?(object)
        defined?(::Sequel::Mysql2::Dataset) && object.class.ancestors.include?(::Sequel::Mysql2::Dataset)
      end

      def format(object)
        af = Formatters::ArrayFormatter.new(@inspector)
        [af.format(dataset.to_a), colorize(dataset.sql, :string)].join("\n")
      end

    end
  end
end
