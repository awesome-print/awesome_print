module AwesomePrint
  module Formatters
    class NokogiriXmlNode < Base

      def call
        if empty?
          return "[]"
        end
        xml = object.to_xml(:indent => 2)
        #
        # Colorize tag, id/class name, and contents.
        #
        xml.gsub!(/(<)(\/?[A-Za-z1-9]+)/) { |tag| "#{$1}#{formatter.colorize($2, :keyword)}" }
        xml.gsub!(/(id|class)="[^"]+"/i) { |id| formatter.colorize(id, :class) }
        xml.gsub!(/>([^<]+)</) do |contents|
          contents = formatter.colorize($1, :trueclass) if contents && !contents.empty?
          ">#{contents}<"
        end
        xml
      end

      private

        def empty?
          object.is_a?(::Nokogiri::XML::NodeSet) && object.empty?
        end
    end
  end
end
