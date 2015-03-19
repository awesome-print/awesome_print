module AwesomePrint
  module Types
    class MongoMapper < Type

      def call
        if object.is_a?(Class) && (object.ancestors & [ ::MongoMapper::Document, ::MongoMapper::EmbeddedDocument ]).size > 0
          :mongo_mapper_class
        elsif object.is_a?(::MongoMapper::Document) || object.is_a?(::MongoMapper::EmbeddedDocument)
          :mongo_mapper_instance
        elsif object.is_a?(::MongoMapper::Plugins::Associations::Base)
          :mongo_mapper_association
        elsif object.is_a?(::BSON::ObjectId)
          :mongo_mapper_bson_id
        end
      end
    end
  end
end
