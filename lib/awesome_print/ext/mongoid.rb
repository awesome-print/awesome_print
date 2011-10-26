module AwesomePrint
  module Mongoid

    def self.included(base)
      base.send :alias_method, :cast_without_mongoid, :cast
      base.send :alias_method, :cast, :cast_with_mongoid
    end

    # Add Mongoid class names to the dispatcher pipeline.
    #------------------------------------------------------------------------------
    def cast_with_mongoid(object, type)
      cast = cast_without_mongoid(object, type)
      if defined?(::Mongoid::Document) && object.is_a?(Class) && object.ancestors.include?(::Mongoid::Document)
        cast = :mongoid_class
      end
      cast
    end

    # Format Mongoid class object.
    #------------------------------------------------------------------------------
    def awesome_mongoid_class(object)
      return object.inspect if !defined?(::ActiveSupport::OrderedHash) || !object.respond_to?(:fields)

      data = object.fields.inject(::ActiveSupport::OrderedHash.new) do |hash, c|
        hash[c[1].name] = (c[1].type || "undefined").to_s.underscore.intern
        # hash[c[1].name] = (c[1].type || "undefined").to_s.underscore.intern rescue c[1].type
        hash
      end
      "class #{object} < #{object.superclass} " << awesome_hash(data)
    end
  end
end

AwesomePrint::Formatter.send(:include, AwesomePrint::Mongoid)
