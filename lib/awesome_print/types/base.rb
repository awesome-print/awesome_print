module AwesomePrint
  module Types
    class Base

      def initialize(object)
        @object = object
      end

      private

        attr_reader :object
    end
  end
end
