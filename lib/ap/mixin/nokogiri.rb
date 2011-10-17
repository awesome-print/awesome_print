module AwesomePrintNokogiri
  def self.included(base)
    base.send :alias_method, :printable_without_nokogiri, :printable
    base.send :alias_method, :printable, :printable_with_nokogiri
  end

  def printable_with_nokogiri(object)
    printable = printable_without_nokogiri(object)
    return printable if !defined?(Nokogiri)
    if printable == :self
      printable = :nokogiri if object.is_a?(Nokogiri::XML::Node) || object.is_a?(Nokogiri::XML::NodeSet)
    end
    printable
  end

  def awesome_nokogiri(object)
    if object.is_a?(Nokogiri::XML::NodeSet) && object.empty?
      return "[]"
    end
    s = object.to_xml(:indent => 2)
    s.gsub!(/(<\/?)([A-Za-z]+)/) { |i| "#{$1}#{colorize($2, :class)}" }
    s.gsub!(/(id|class)="[^"]+"/) { |i| colorize(i, :bigdecimal) }
    s.gsub!(/>([^<]+)</) do |i|
      i = colorize($1, :nilclass) if i.present?
      ">#{i}<"
    end
    s
  end
end

AwesomePrint.send(:include, AwesomePrintNokogiri)
