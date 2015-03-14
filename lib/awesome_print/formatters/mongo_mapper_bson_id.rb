module AwesomePrint
  module Formatters
    class MongoMapperBsonId < Base

      def call
        object.inspect
      end
    end
  end
end
