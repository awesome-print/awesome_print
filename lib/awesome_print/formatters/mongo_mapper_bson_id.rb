module AwesomePrint
  module Formatters
    class MongoMapperBsonId < Formatter

      def call
        object.inspect
      end
    end
  end
end
