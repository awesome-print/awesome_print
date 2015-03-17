require 'awesome_print/formatters'

module AwesomePrint
  class FormatterFactory

    def initialize(class_name, formatter, object)
      @class_name = class_name.to_s.split('_').map(&:capitalize).join('')
      @formatter = formatter
      @object = object
    end

    def call
      klass = AwesomePrint::Support.constantize("AwesomePrint::Formatters::#{class_name}")
      klass.new(formatter, object).call
    end

    private

      attr_reader :class_name, :formatter, :object
  end
end
