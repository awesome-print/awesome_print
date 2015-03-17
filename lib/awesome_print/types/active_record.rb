module AwesomePrint
  module Types
    class ActiveRecord < Base

      def call
        if object.is_a?(::ActiveRecord::Base)
          :active_record_instance
        elsif object.is_a?(Class) && object.ancestors.include?(::ActiveRecord::Base)
          :active_record_class
        elsif object.class.ancestors.include?(::ActiveRecord::Relation)
          :array
        end
      end
    end
  end
end
