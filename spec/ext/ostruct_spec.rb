require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

begin
  require 'ostruct'
  require 'awesome_print/ext/ostruct'

  describe 'AwesomePrint Ostruct extension' do
    before do
      stub_dotfile!
      @ap = AwesomePrint::Inspector.new(:plain => true, :sort_keys => true)
    end

    it "empty hash" do
      struct = OpenStruct.new
      @ap.send(:awesome, struct).should == "OpenStruct {}"
    end

    it "plain multiline" do
      struct = OpenStruct.new :name => "Marshall Shen", :address => "605 Madion St."
      @ap.send(:awesome, struct).should == <<-EOS.strip
OpenStruct {
    :address => "605 Madion St.",
       :name => "Marshall Shen"
}
EOS
    end
  end

rescue LoadError => error
  puts "Skipping OpenStruct specs: #{error}"
end