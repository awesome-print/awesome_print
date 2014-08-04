module AwesomePrint
  module DataMapper

    def self.included(base)
      base.send :alias_method, :cast_without_data_mapper, :cast
      base.send :alias_method, :cast, :cast_with_data_mapper
    end

    # Add DataMapper class names to the dispatcher pipeline.
    #------------------------------------------------------------------------------
    def cast_with_data_mapper(object, type)
      cast = cast_without_data_mapper(object, type)
      return cast if !defined?(::DataMapper)

      if object.is_a?(::DataMapper::Resource)
        cast = :data_mapper_instance
      elsif object.is_a?(Class) && object.ancestors.include?(::DataMapper::Resource)
        cast = :data_mapper_class
      end
      cast
    end

    private

    # Format DataMapper instance object.
    #
    # NOTE: by default only instance attributes (i.e. columns) are shown. To format
    # DataMapper instance as regular object showing its instance variables and
    # accessors use :raw => true option:
    #
    # ap record, :raw => true
    #
    #------------------------------------------------------------------------------
    def awesome_data_mapper_instance(object)
      return object.inspect if !defined?(::ActiveSupport::OrderedHash)
      return awesome_object(object) if @options[:raw]

      data = object.class.properties.map(&:name).inject(::ActiveSupport::OrderedHash.new) do |hash, name|
        value = object.respond_to?(name) ? object.send(name) : object.read_attribute(name)
        hash[name.to_sym] = value
        hash
      end
      "#{object} " << awesome_hash(data)
    end

    # Format DataMapper class object.
    #------------------------------------------------------------------------------
    def awesome_data_mapper_class(object)
      return object.inspect if !defined?(::ActiveSupport::OrderedHash) || !object.respond_to?(:properties)

      data = object.properties.inject(::ActiveSupport::OrderedHash.new) do |hash, c|
        hash[c.name.to_sym] = c.class
        hash
      end
      "class #{object} < #{object.superclass} " << awesome_hash(data)
    end
  end
end

AwesomePrint::Formatter.send(:include, AwesomePrint::DataMapper)
