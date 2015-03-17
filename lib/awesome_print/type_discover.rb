require 'awesome_print/types'

module AwesomePrint
  class TypeDiscover

    TYPES = %w(ActiveRecord ActiveSupport Mongoid MongoMapper NoBrainer Nokogiri OpenStruct)

    def initialize(object)
      @object = object
    end

    def call
      TYPES.map do |type|
        begin
          klass = AwesomePrint::Support.constantize("AwesomePrint::Types::#{type}")
          klass.new(object).call
        rescue NameError
          nil
        end
      end.detect { |type| !type.nil? }
    end

    private

      attr_reader :object
  end
end
