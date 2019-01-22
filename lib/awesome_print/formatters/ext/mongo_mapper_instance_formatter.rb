require_relative '../base_formatter'

module AwesomePrint
  module Formatters
    class MongoMapperInstanceFormatter < BaseFormatter

      formatter_for :mongo_mapper_instance

      def self.formattable?(object)
        defined?(::MongoMapper) &&
          (object.is_a?(::MongoMapper::Document) ||
          object.is_a?(::MongoMapper::EmbeddedDocument))
      end

      def initialize(inspector)
        super(inspector)

        @options[:color][:assoc] ||= :greenish
        @options[:mongo_mapper]  ||= {
          show_associations: false, # Display association data for MongoMapper documents and classes.
          inline_embedded: false    # Display embedded associations inline with MongoMapper documents.
        }
      end

      # Format MongoMapper instance object.
      #
      # NOTE: by default only instance attributes (i.e. keys) are shown. To format
      # MongoMapper instance as regular object showing its instance variables and
      # accessors use :raw => true option:
      #
      # ap record, :raw => true
      #
      #------------------------------------------------------------------------------
      def format(object)
        if @options[:raw]
          return Formatters::ObjectFormatter.new(@inspector).format(object)
        end

        if !defined?(::ActiveSupport::OrderedHash)
          return Formatters::SimpleFormatter.new(@inspector).format(object.inspect.to_s)
        end

        data = object.keys.keys.sort_by { |k| k }.inject(::ActiveSupport::OrderedHash.new) do |hash, name|
          hash[name] = object[name]
          hash
        end

        # Add in associations
        if @options[:mongo_mapper][:show_associations]
          object.associations.each do |name, assoc|
            data[name.to_s] = if @options[:mongo_mapper][:inline_embedded] and assoc.embeddable?
                                object.send(name)
                              else
                                assoc
                              end
          end
        end

        label = object.to_s
        label = "#{colorize('embedded', :assoc)} #{label}" if object.is_a?(::MongoMapper::EmbeddedDocument)

        "#{label} " << Formatters::HashFormatter.new(@inspector).format(data)
      end

    end
  end
end
