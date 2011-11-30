require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

begin
  require "nokogiri"
  require "awesome_print/ext/nokogiri"

  describe "AwesomePrint/Nokogiri" do
    before do
      stub_dotfile!
    end

    it "should colorize tags" do
      xml = Nokogiri::XML('<html><body><h1></h1></body></html>')
      xml.ai.should ==  <<-EOS
<?xml version=\"1.0\"?>\e[1;32m
\e[0m<\e[1;36mhtml\e[0m>\e[1;32m
  \e[0m<\e[1;36mbody\e[0m>\e[1;32m
    \e[0m<\e[1;36mh1\e[0m/>\e[1;32m
  \e[0m<\e[1;36m/body\e[0m>\e[1;32m
\e[0m<\e[1;36m/html\e[0m>
EOS
    end

    it "should colorize contents" do
      xml = Nokogiri::XML('<html><body><h1>Hello</h1></body></html>')
      xml.ai.should ==  <<-EOS
<?xml version=\"1.0\"?>\e[1;32m
\e[0m<\e[1;36mhtml\e[0m>\e[1;32m
  \e[0m<\e[1;36mbody\e[0m>\e[1;32m
    \e[0m<\e[1;36mh1\e[0m>\e[1;32mHello\e[0m<\e[1;36m/h1\e[0m>\e[1;32m
  \e[0m<\e[1;36m/body\e[0m>\e[1;32m
\e[0m<\e[1;36m/html\e[0m>
EOS
    end

    it "should colorize class and id" do
      xml = Nokogiri::XML('<html><body><h1><span id="hello" class="world"></span></h1></body></html>')
      xml.ai.should ==  <<-EOS
<?xml version=\"1.0\"?>\e[1;32m
\e[0m<\e[1;36mhtml\e[0m>\e[1;32m
  \e[0m<\e[1;36mbody\e[0m>\e[1;32m
    \e[0m<\e[1;36mh1\e[0m>\e[1;32m
      \e[0m<\e[1;36mspan\e[0m \e[1;33mid=\"hello\"\e[0m \e[1;33mclass=\"world\"\e[0m/>\e[1;32m
    \e[0m<\e[1;36m/h1\e[0m>\e[1;32m
  \e[0m<\e[1;36m/body\e[0m>\e[1;32m
\e[0m<\e[1;36m/html\e[0m>
EOS
    end
  end

rescue LoadError => error
  puts "Skipping Nokogiri specs: #{error}"
end
