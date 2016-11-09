require 'spec_helper'

RSpec.describe 'AwesomePrint/Nokogiri' do
  it 'should colorize tags' do
    xml = Nokogiri::XML('<html><body><h1></h1></body></html>')
    expect(xml.ai).to eq <<-EOS
<?xml version=\"1.0\"?>\e[1;32m
\e[0m<\e[1;36mhtml\e[0m>\e[1;32m
  \e[0m<\e[1;36mbody\e[0m>\e[1;32m
    \e[0m<\e[1;36mh1\e[0m/>\e[1;32m
  \e[0m<\e[1;36m/body\e[0m>\e[1;32m
\e[0m<\e[1;36m/html\e[0m>
    EOS
  end

  it 'should colorize contents' do
    xml = Nokogiri::XML('<html><body><h1>Hello</h1></body></html>')
    expect(xml.ai).to eq <<-EOS
<?xml version=\"1.0\"?>\e[1;32m
\e[0m<\e[1;36mhtml\e[0m>\e[1;32m
  \e[0m<\e[1;36mbody\e[0m>\e[1;32m
    \e[0m<\e[1;36mh1\e[0m>\e[1;32mHello\e[0m<\e[1;36m/h1\e[0m>\e[1;32m
  \e[0m<\e[1;36m/body\e[0m>\e[1;32m
\e[0m<\e[1;36m/html\e[0m>
    EOS
  end

  it 'should colorize class and id' do
    xml = Nokogiri::XML('<html><body><h1><span id="hello" class="world"></span></h1></body></html>')
    expect(xml.ai).to eq <<-EOS
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

  it 'handle empty NodeSet' do
    xml = Nokogiri::XML::NodeSet.new(Nokogiri::XML(''))
    expect(xml.ai).to eq('[]')
  end
end
