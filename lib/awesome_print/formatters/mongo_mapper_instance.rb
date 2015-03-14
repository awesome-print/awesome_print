require 'awesome_print/formatters/mongo_mapper'

module AwesomePrint
  module Formatters
    class MongoMapperInstance < Base
      include MongoMapper

      # Format MongoMapper instance object.
      #
      # NOTE: by default only instance attributes (i.e. keys) are shown. To format
      # MongoMapper instance as regular object showing its instance variables and
      # accessors use :raw => true option:
      #
      # ap record, :raw => true
      #
      #------------------------------------------------------------------------------
      def call
        return object.inspect if !defined?(::ActiveSupport::OrderedHash)
        return AwesomePrint::Formatters::Object.new(formatter, object).call if options[:raw]

        "#{label} " << AwesomePrint::Formatters::Hash.new(formatter, columns).call
      end

      private

        def label
          label = object.to_s
          label = "#{formatter.colorize('embedded', :assoc)} #{label}" if object.is_a?(::MongoMapper::EmbeddedDocument)
          label
        end

        def columns
          data = object.keys.keys.sort_by{|k| k}.inject(::ActiveSupport::OrderedHash.new) do |hash, name|
            hash[name] = object[name]
            hash
          end

          # Add in associations
          if options[:mongo_mapper][:show_associations]
            object.associations.each do |name, assoc|
              if options[:mongo_mapper][:inline_embedded] and assoc.embeddable?
                data[name.to_s] = object.send(name)
              else
                data[name.to_s] = assoc
              end
            end
          end
          data
        end
    end
  end
end
