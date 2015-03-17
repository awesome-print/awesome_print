module AwesomePrint
  module Types
    class OpenStruct < Base

      def call
        if (defined?(::OpenStruct)) && (object.is_a?(::OpenStruct))
          :open_struct_instance
        end
      end
    end
  end
end
