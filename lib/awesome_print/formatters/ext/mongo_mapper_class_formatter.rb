require_relative '../base_formatter'

module AwesomePrint
  module Formatters
    class MongoMapperClassFormatter < BaseFormatter

      formatter_for :mongo_mapper_class

      def self.formattable?(object)
        defined?(::MongoMapper) &&
          object.is_a?(Class) &&
          (object.ancestors & [::MongoMapper::Document, ::MongoMapper::EmbeddedDocument]).size > 0
      end

      def format(object)
      unless defined?(::ActiveSupport::OrderedHash) && object.respond_to?(:keys)
        return Formatters::SimpleFormatter.new(@inspector).format(object.inspect.to_s)
      end

      data = object.keys.sort.inject(::ActiveSupport::OrderedHash.new) do |hash, c|
        hash[c.first] = (c.last.type || 'undefined').to_s.underscore.to_sym
        hash
      end

      # Add in associations
      if @options[:mongo_mapper][:show_associations]
        object.associations.each { |name, assoc| data[name.to_s] = assoc }
      end

      sf = Formatters::SimpleFormatter.new(@inspector)

      [
        "class #{sf.format(object.to_s, :class)}",
        "< #{sf.format(object.superclass.to_s, :class)}",
        Formatters::HashFormatter.new(@inspector).format(data)
      ].join(' ')
      end

    end
  end
end
