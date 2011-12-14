require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

begin
  require "mongoid"
  require "awesome_print/ext/mongoid"

  describe "AwesomePrint/Mongoid" do
    before :all do
      class MongoUser
        include Mongoid::Document

        field :first_name, :type => String
        field :last_name,  :type => String
      end
    end

    before do 
      @ap = AwesomePrint::Inspector.new :plain => true, :sort_keys => true
    end

    it "should print class instance" do
      user = MongoUser.new :first_name => "Al", :last_name => "Capone"
      out = @ap.send :awesome, user

      str = <<-EOS.strip
#<MongoUser:0x01234567> {
           :_id => BSON::ObjectId('424242424242424242424242'),
    :first_name => "Al",
     :last_name => "Capone"
}
EOS
      out.gsub!(/0x([a-f\d]+)/, "0x01234567")
      out.gsub!(/Id\('[^']+/, "Id('424242424242424242424242")
      out.should == str
    end

    it "should print the class" do
      @ap.send(:awesome, MongoUser).should == <<-EOS.strip
class MongoUser < Object {
           :_id => :"bson/object_id",
         :_type => :string,
    :first_name => :string,
     :last_name => :string
}
EOS
    end

    it "should print the class when type is undefined" do
      class Chamelion
        include Mongoid::Document
        field :last_attribute
      end

      @ap.send(:awesome, Chamelion).should == <<-EOS.strip
class Chamelion < Object {
               :_id => :"bson/object_id",
             :_type => :string,
    :last_attribute => :"mongoid/fields/serializable/object"
}
EOS
    end
  end

rescue LoadError => error
  puts "Skipping Mongoid specs: #{error}"
end
