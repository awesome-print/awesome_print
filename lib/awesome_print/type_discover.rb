require 'awesome_print/types'

module AwesomePrint
  class TypeDiscover

    BUILT_IN_TYPES = [ :array, :bigdecimal, :class, :dir, :file, :hash, :method, :rational, :set, :struct, :unboundmethod ]
    CUSTOM_TYPES = %w(ActiveRecord ActiveSupport Mongoid MongoMapper NoBrainer Nokogiri
               OpenStruct Ripple Sequel)

    def initialize(formatter)
      @type = formatter.type
      @object = formatter.object
    end

    def call
      custom_type || built_in_type || :self
    end

    private

      attr_reader :object, :type

      def custom_type
        CUSTOM_TYPES.map do |type|
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
  end
end
