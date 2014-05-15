require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

begin
  require 'ripple'
  require 'awesome_print/ext/ripple'

  describe 'AwesomePrint/Ripple' do
    before :all do
      class RippleUser
        include Ripple::Document

        key_on :_id
        property :_id, String
        property :first_name, String
        property :last_name,  String
      end
    end

    after :all do
      Object.instance_eval { remove_const :RippleUser }
    end

    before do
      stub_dotfile!
      @ap = AwesomePrint::Inspector.new :plain => true, :sort_keys => true
    end

    it "should print class instance" do
      user = RippleUser.new :_id => "12345", :first_name => "Al", :last_name => "Capone"
      out = @ap.send :awesome, user

      expect(out).to eq <<-EOS.strip
#<RippleUser:12345> {
           :_id => "12345",
    :first_name => "Al",
     :last_name => "Capone"
}
EOS
    end

    it "should print the class" do
      expect(@ap.send(:awesome, RippleUser)).to eq <<-EOS.strip
class RippleUser < Object {
           :_id => :string,
         :_type => :string,
    :first_name => :string,
     :last_name => :string
}
EOS
    end
  end

rescue LoadError => error
  puts "Skipping Ripple specs: #{error}"
end
