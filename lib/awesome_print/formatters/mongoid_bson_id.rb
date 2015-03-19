module AwesomePrint
  module Formatters
    class MongoidBsonId < Formatter

      def call
        object.inspect
      end
    end
  end
end
