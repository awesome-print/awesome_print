module AwesomePrint
  module Types
    class Nokogiri < Base

      def call
        if (defined?(::Nokogiri::XML::Node) && object.is_a?(::Nokogiri::XML::Node)) ||
            (defined?(::Nokogiri::XML::NodeSet) && object.is_a?(::Nokogiri::XML::NodeSet))
          :nokogiri_xml_node
        end
      end
    end
  end
end
