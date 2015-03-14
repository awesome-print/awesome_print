module AwesomePrint
  module OpenStruct
    def self.included(base)
      base.send :alias_method, :cast_without_ostruct, :cast
      base.send :alias_method, :cast, :cast_with_ostruct
    end

    def cast_with_ostruct(object, type)
      cast = cast_without_ostruct(object, type)
      if (defined?(::OpenStruct)) && (object.is_a?(::OpenStruct))
        cast = :open_struct_instance
      end
      cast
    end

    def awesome_open_struct_instance(object)
      AwesomePrint::Formatters::OpenStructInstance.new(self, object).call
    end
  end
end

AwesomePrint::Formatter.send(:include, AwesomePrint::OpenStruct)
