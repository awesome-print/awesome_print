module AwesomePrint
  module Formatters
    class MongoMapperAssociation < Formatter

      def call
        return object.inspect if !defined?(::ActiveSupport::OrderedHash)
        return awesome_object(object) if @options[:raw]

        association = object.class.name.split('::').last.titleize.downcase.sub(/ association$/,'')
        association = "embeds #{association}" if object.embeddable?
        class_name = object.class_name

        "#{formatter.colorize(association, :assoc)} #{formatter.colorize(class_name, :class)}"
      end
    end
  end
end
