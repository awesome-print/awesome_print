module AwesomePrint
  module Types
    class OpenStruct < Type

      def call
        if (defined?(::OpenStruct)) && (object.is_a?(::OpenStruct))
          :open_struct_instance
        end
      end
    end
  end
end
