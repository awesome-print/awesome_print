require_relative '../base_formatter'

module AwesomePrint
  module Formatters
    class MongoMapperClassFormatter < BaseFormatter

      formatter_for :mongo_mapper_association

      def self.formattable?(object)
        defined?(::MongoMapper) && object.is_a?(::MongoMapper::Plugins::Associations::Base)
      end

      def format(object)
        if @options[:raw]
          return Formatters::ObjectFormatter.new(@inspector).format(object)
        end

        if !defined?(::ActiveSupport::OrderedHash)
          return Formatters::SimpleFormatter.new(@inspector).format(object.inspect.to_s)
        end

        association = object.class.name.split('::').last.titleize.downcase.sub(/ association$/, '')
        association = "embeds #{association}" if object.embeddable?
        class_name = object.class_name

        "#{colorize(association, :assoc)} #{colorize(class_name, :class)}"
      end

    end
  end
end
