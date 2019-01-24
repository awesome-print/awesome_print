require_relative 'formatter'

module AwesomePrint
  module Registrar

    def self.included(base)
      base.send(:extend, ClassMethods)
    end

    module ClassMethods

      attr_accessor :formatted_object_type

      def formatter_for(type)
        self.formatted_object_type = type

        AwesomePrint::Formatter.register(self)
      end
    end

  end
end
