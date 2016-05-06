module AwesomePrint
  module Types
    class Type

      def initialize(object)
        @object = object
      end

      private

        attr_reader :object
    end
  end
end
