require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

begin
  require "mongoid"
  require "ap/mixin/mongoid"

  describe "AwesomePrint/Mongoid" do
    before :all do
      Object.instance_eval { remove_const :User } if defined?(User)      
      class User
        include Mongoid::Document
        field :first_name
        field :last_name
      end
    end

    let(:ap) do
      AwesomePrint.new(:plain => true)
    end

    it "should print for a class instance" do
      user = User.new(:first_name => "Al", :last_name => "Capone")
      out = ap.send(:awesome, user)
      str = <<-EOS.strip
#<User:0x01234567> {
           :_id => BSON::ObjectId('4d9183739a546f6806000001'),
    :first_name => "Al",
     :last_name => "Capone"
}
EOS
      out.gsub!(/'([\w]+){23}'/, "'4d9183739a546f6806000001'")
      out.gsub!(/0x([a-f\d]+)/, "0x01234567")
      out.should == str
    end

    it "should print for a class" do
      ap.send(:awesome, User).should == <<-EOS.strip
class User < Object {
           :_id => BSON::ObjectId < Object,
         :_type => String < Object,
    :first_name => Mongoid::Fields::Serializable::Object < Object,
     :last_name => Mongoid::Fields::Serializable::Object < Object
}
EOS
    end
  end

rescue LoadError
  puts "Skipping Mongoid specs..."
end
