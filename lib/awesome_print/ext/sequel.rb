module AwesomePrint
  module Sequel

    def self.included(base)
      base.send :alias_method, :cast_without_sequel, :cast
      base.send :alias_method, :cast, :cast_with_sequel
    end

    # Add Sequel class names to the dispatcher pipeline.
    #------------------------------------------------------------------------------
    def cast_with_sequel(object, type)
      cast = cast_without_sequel(object, type)
      if defined?(::Sequel::Model) && object.is_a?(::Sequel::Model)
        cast = :sequel_document
      elsif defined?(::Sequel::Model) && object.is_a?(Class) && object.ancestors.include?(::Sequel::Model)
        cast = :sequel_model_class
      elsif defined?(::Sequel::Mysql2::Dataset) && object.class.ancestors.include?(::Sequel::Mysql2::Dataset)
        cast = :sequel_dataset
      end
      cast
    end

    # Format Sequel Document object.
    #------------------------------------------------------------------------------
    def awesome_sequel_document(object)
      AwesomePrint::Formatters::SequelDocument.new(self, object).call
    end

    # Format Sequel Dataset object.
    #------------------------------------------------------------------------------
    def awesome_sequel_dataset(object)
      AwesomePrint::Formatters::SequelDataset.new(self, object).call
    end

    # Format Sequel Model class.
    #------------------------------------------------------------------------------
    def awesome_sequel_model_class(object)
      AwesomePrint::Formatters::SequelModelClass.new(self, object).call
    end
  end

end

AwesomePrint::Formatter.send(:include, AwesomePrint::Sequel)
