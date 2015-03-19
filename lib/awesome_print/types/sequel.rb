module AwesomePrint
  module Types
    class Sequel < Type

      def call
        if defined?(::Sequel::Model) && object.is_a?(::Sequel::Model)
          :sequel_document
        elsif defined?(::Sequel::Model) && object.is_a?(Class) && object.ancestors.include?(::Sequel::Model)
          :sequel_model_class
        elsif defined?(::Sequel::Mysql2::Dataset) && object.class.ancestors.include?(::Sequel::Mysql2::Dataset)
          :sequel_dataset
        end
      end
    end
  end
end
