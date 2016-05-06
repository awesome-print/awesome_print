require 'awesome_print/types/type'

module AwesomePrint
  class TypeDiscover

    BUILT_IN_TYPES = [ :array, :bigdecimal, :class, :dir, :file, :hash, :method, :rational, :set, :struct, :unboundmethod ]

    def initialize(formatter)
      @type = formatter.type
      @object = formatter.object
      @custom_types = []
      require_custom_types
    end

    def call
      custom_type || built_in_type || :self
    end

    private

      attr_reader :object, :type, :custom_types

      def custom_type
        custom_types.map do |type|
          begin
            klass = AwesomePrint::Support.constantize("AwesomePrint::Types::#{type}")
            klass.new(object).call
          rescue NameError
            nil
          end
        end.detect { |type| !type.nil? }
      end

      def built_in_type
        BUILT_IN_TYPES.grep(type)[0]
      end

      def require_custom_types
        Dir[File.dirname(__FILE__) + '/types/*.rb'].each do |file|
          add_custom_type(file)
          require file
        end
      end

      def add_custom_type(file)
        file_name = File.basename(file, '.rb')
        @custom_types << AwesomePrint::Support.camelize(file_name)
      end
  end
end
