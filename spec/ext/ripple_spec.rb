require 'spec_helper'

RSpec.describe 'AwesomePrint/Ripple', skip: ->{ !ExtVerifier.has_ripple? }.call do

  if ExtVerifier.has_ripple?
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
  end

  before do
    stub_dotfile!
    @ap = AwesomePrint::Inspector.new :plain => true, :sort_keys => true
  end

  it "should print class instance" do
    user = RippleUser.new :_id => "12345", :first_name => "Al", :last_name => "Capone"
    out = @ap.send :awesome, user

    expect(out.gsub(/0x([a-f\d]+)/, "0x01234567")).to eq <<-EOS.strip
#<RippleUser:0x01234567> {
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
    :first_name => :string,
     :last_name => :string
}
    EOS
  end
end
