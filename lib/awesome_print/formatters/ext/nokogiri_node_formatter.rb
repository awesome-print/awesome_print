require_relative '../base_formatter'

module AwesomePrint
  module Formatters
    class NokogiriNodeFormatter < BaseFormatter

      formatter_for :nokogiri_xml_node

      def self.formattable?(object)
        defined?(::Nokogiri) && object.is_a?(::Nokogiri::XML::Node)
      end

      def format(object)
        xml = object.to_xml(indent: 2)
        #
        # Colorize tag, id/class name, and contents.
        #
        xml.gsub!(/(<)(\/?[A-Za-z1-9]+)/) { |tag| "#{$1}#{colorize($2, :keyword)}" }
        xml.gsub!(/(id|class)="[^"]+"/i) { |id| colorize(id, :class) }
        xml.gsub!(/>([^<]+)</) do |contents|
          contents = colorize($1, :trueclass) if contents && !contents.empty?
          ">#{contents}<"
        end
        xml
      end

    end
  end
end
