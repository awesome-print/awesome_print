module AwesomePrint
  module Types
    class Mongoid < Base

      def call
        if object.is_a?(Class) && object.ancestors.include?(::Mongoid::Document)
          :mongoid_class
        elsif object.class.ancestors.include?(::Mongoid::Document)
          :mongoid_document
        elsif (defined?(::BSON) && object.is_a?(::BSON::ObjectId)) || (defined?(::Moped::BSON) && object.is_a?(::Moped::BSON::ObjectId))
          :mongoid_bson_id
        end
      end
    end
  end
end
