module AwesomePrint
  module Nokogiri

    def self.included(base)
      base.send :alias_method, :cast_without_nokogiri, :cast
      base.send :alias_method, :cast, :cast_with_nokogiri
    end

    # Add Nokogiri XML Node and NodeSet names to the dispatcher pipeline.
    #------------------------------------------------------------------------------
    def cast_with_nokogiri(object, type)
      cast = cast_without_nokogiri(object, type)
      if (defined?(::Nokogiri::XML::Node) && object.is_a?(::Nokogiri::XML::Node)) ||
         (defined?(::Nokogiri::XML::NodeSet) && object.is_a?(::Nokogiri::XML::NodeSet))
        cast = :nokogiri_xml_node
      end
      cast
    end

    #------------------------------------------------------------------------------
    def awesome_nokogiri_xml_node(object)
      AwesomePrint::Formatters::NokogiriXmlNode.new(self, object).call
    end
  end
end

AwesomePrint::Formatter.send(:include, AwesomePrint::Nokogiri)
