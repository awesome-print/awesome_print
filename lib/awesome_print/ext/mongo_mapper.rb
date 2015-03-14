module AwesomePrint
  module MongoMapper

    def self.included(base)
      base.send :alias_method, :cast_without_mongo_mapper, :cast
      base.send :alias_method, :cast, :cast_with_mongo_mapper
    end

    # Add MongoMapper class names to the dispatcher pipeline.
    #------------------------------------------------------------------------------
    def cast_with_mongo_mapper(object, type)
      cast = cast_without_mongo_mapper(object, type)

      if defined?(::MongoMapper::Document)
        if object.is_a?(Class) && (object.ancestors & [ ::MongoMapper::Document, ::MongoMapper::EmbeddedDocument ]).size > 0
          cast = :mongo_mapper_class
        elsif object.is_a?(::MongoMapper::Document) || object.is_a?(::MongoMapper::EmbeddedDocument)
          cast = :mongo_mapper_instance
        elsif object.is_a?(::MongoMapper::Plugins::Associations::Base)
          cast = :mongo_mapper_association
        elsif object.is_a?(::BSON::ObjectId)
          cast = :mongo_mapper_bson_id
        end
      end

      cast
    end

    # Format MongoMapper class object.
    #------------------------------------------------------------------------------
    def awesome_mongo_mapper_class(object)
      AwesomePrint::Formatters::MongoMapperClass.new(self, object).call
    end

    def awesome_mongo_mapper_instance(object)
      AwesomePrint::Formatters::MongoMapperInstance.new(self, object).call
    end

    # Format MongoMapper association object.
    #------------------------------------------------------------------------------
    def awesome_mongo_mapper_association(object)
      AwesomePrint::Formatters::MongoMapperAssociation.new(self, object).call
    end

    # Format BSON::ObjectId
    #------------------------------------------------------------------------------
    def awesome_mongo_mapper_bson_id(object)
      AwesomePrint::Formatters::MongoMapperBsonId.new(self, object).call
    end
  end
end

AwesomePrint::Formatter.send(:include, AwesomePrint::MongoMapper)
