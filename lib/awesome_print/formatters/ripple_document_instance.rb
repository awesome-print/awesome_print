module AwesomePrint
  module Formatters
    class RippleDocumentInstance < Base

      # Format Ripple instance object.
      #
      # NOTE: by default only instance attributes are shown. To format a Ripple document instance
      # as a regular object showing its instance variables and accessors use :raw => true option:
      #
      # ap document, :raw => true
      #
      #------------------------------------------------------------------------------
      def call
        return object.inspect if !defined?(::ActiveSupport::OrderedHash)
        return AwesomePrint::Formatters::Object.new(formatter, object).call if options[:raw]

        "#{object} " << AwesomePrint::Formatters::Hash.new(formatter, columns).call
      end

      private

        def columns
          exclude_assoc = options[:exclude_assoc] or options[:exclude_associations]

          data = object.attributes.inject(::ActiveSupport::OrderedHash.new) do |hash, (name, value)|
            hash[name.to_sym] = object.send(name)
            hash
          end

          unless exclude_assoc
            data = object.class.embedded_associations.inject(data) do |hash, assoc|
              hash[assoc.name] = object.get_proxy(assoc) # Should always be array or Ripple::EmbeddedDocument for embedded associations
              hash
            end
          end
          data
        end
    end
  end
end
