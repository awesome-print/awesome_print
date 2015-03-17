module AwesomePrint
  module Types
    class ActiveRecord

      def initialize(object)
        @object = object
      end

      def call
        if object.is_a?(::ActiveRecord::Base)
          :active_record_instance
        elsif object.is_a?(Class) && object.ancestors.include?(::ActiveRecord::Base)
          :active_record_class
        elsif object.class.ancestors.include?(::ActiveRecord::Relation)
          :array
        end
      end

      private

        attr_reader :object
    end
  end
end
