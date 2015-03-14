module AwesomePrint
  module Formatters
    class MongoidBsonId < Base

      def call
        object.inspect
      end
    end
  end
end
