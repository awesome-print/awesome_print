module AwesomePrint
  module Mongoid

    def self.included(base)
      base.send :alias_method, :cast_without_mongoid, :cast
      base.send :alias_method, :cast, :cast_with_mongoid
    end

    # Add Mongoid class names to the dispatcher pipeline.
    #------------------------------------------------------------------------------
    def cast_with_mongoid(object, type)
      cast = cast_without_mongoid(object, type)
      if defined?(::Mongoid::Document)
        if object.is_a?(Class) && object.ancestors.include?(::Mongoid::Document)
          cast = :mongoid_class
        elsif object.class.ancestors.include?(::Mongoid::Document)
          cast = :mongoid_document
        elsif (defined?(::BSON) && object.is_a?(::BSON::ObjectId)) || (defined?(::Moped::BSON) && object.is_a?(::Moped::BSON::ObjectId))
          cast = :mongoid_bson_id
        end
      end
      cast
    end
  end
end

AwesomePrint::Formatter.send(:include, AwesomePrint::Mongoid)
