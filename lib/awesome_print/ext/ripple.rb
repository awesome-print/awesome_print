module AwesomePrint
  module Ripple

    def self.included(base)
      base.send :alias_method, :cast_without_ripple, :cast
      base.send :alias_method, :cast, :cast_with_ripple
    end

    # Add Ripple class names to the dispatcher pipeline.
    #------------------------------------------------------------------------------
    def cast_with_ripple(object, type)
      cast = cast_without_ripple(object, type)
      return cast if !defined?(::Ripple)

      if object.is_a?(::Ripple::AttributeMethods) # Module used to access attributes across documents and embedded documents
        cast = :ripple_document_instance
      elsif object.is_a?(::Ripple::Properties)    # Used to access property metadata on Ripple classes
        cast = :ripple_document_class
      end
      cast
    end

    private

    # Format Ripple instance object.
    #
    # NOTE: by default only instance attributes are shown. To format a Ripple document instance
    # as a regular object showing its instance variables and accessors use :raw => true option:
    #
    # ap document, :raw => true
    #
    #------------------------------------------------------------------------------
    def awesome_ripple_document_instance(object)
      AwesomePrint::Formatters::RippleDocumentInstance.new(self, object).call
    end

    # Format Ripple class object.
    #------------------------------------------------------------------------------
    def awesome_ripple_document_class(object)
      AwesomePrint::Formatters::RippleDocumentClass.new(self, object).call
    end
  end
end

AwesomePrint::Formatter.send(:include, AwesomePrint::Ripple)
