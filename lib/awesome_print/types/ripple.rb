module AwesomePrint
  module Types
    class Ripple < Type

      def call
        if object.is_a?(::Ripple::AttributeMethods) # Module used to access attributes across documents and embedded documents
          :ripple_document_instance
        elsif object.is_a?(::Ripple::Properties)    # Used to access property metadata on Ripple classes
          :ripple_document_class
        end
      end
    end
  end
end
