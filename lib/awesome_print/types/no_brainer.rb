module AwesomePrint
  module Types
    class NoBrainer < Type

      def call
        if object.is_a?(Class) && object < ::NoBrainer::Document
          :nobrainer_class
        elsif object.is_a?(::NoBrainer::Document)
          :nobrainer_document
        end
      end
    end
  end
end
