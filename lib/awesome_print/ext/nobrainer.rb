module AwesomePrint
  module NoBrainer

    def self.included(base)
      base.send :alias_method, :cast_without_nobrainer, :cast
      base.send :alias_method, :cast, :cast_with_nobrainer
    end

    # Add NoBrainer class names to the dispatcher pipeline.
    #------------------------------------------------------------------------------
    def cast_with_nobrainer(object, type)
      cast = cast_without_nobrainer(object, type)
      if defined?(::NoBrainer::Document)
        if object.is_a?(Class) && object < ::NoBrainer::Document
          cast = :nobrainer_class
        elsif object.is_a?(::NoBrainer::Document)
          cast = :nobrainer_document
        end
      end
      cast
    end

    # Format NoBrainer class object.
    #------------------------------------------------------------------------------
    def awesome_nobrainer_class(object)
      AwesomePrint::Formatters::NoBrainerClass.new(self, object).call
    end

    # Format NoBrainer Document object.
    #------------------------------------------------------------------------------
    def awesome_nobrainer_document(object)
      AwesomePrint::Formatters::NoBrainerDocument.new(self, object).call
    end
  end
end

AwesomePrint::Formatter.send(:include, AwesomePrint::NoBrainer)
