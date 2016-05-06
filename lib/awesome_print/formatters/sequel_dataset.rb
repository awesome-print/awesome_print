module AwesomePrint
  module Formatters
    class SequelDataset < Formatter

      def call
        [AwesomePrint::Formatters::Array.new(formatter, object.to_a).call,
         awesome_print(dataset.sql)].join("\n")
      end
    end
  end
end
