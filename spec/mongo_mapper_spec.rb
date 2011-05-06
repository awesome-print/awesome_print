require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

begin
  require "mongo_mapper"
  require "ap/mixin/mongo_mapper"

  describe "AwesomePrint/MongoMapper" do
    before :all do
      class MongoUser
        include MongoMapper::Document

        key :first_name, String
        key :last_name, String
      end
    end

    before :each do
      @ap = AwesomePrint.new(:plain => true)
    end

    it "should print for a class instance" do
      user = MongoUser.new(:first_name => "Al", :last_name => "Capone")
      out = @ap.send(:awesome, user)
      str = <<-EOS.strip
#<MongoUser:0x01234567> {
           "_id" => BSON::ObjectId('4d9183739a546f6806000001'),
    "first_name" => "Al",
     "last_name" => "Capone"
}
EOS
      out.gsub!(/'([\w]+){23}'/, "'4d9183739a546f6806000001'")
      out.gsub!(/0x([a-f\d]+)/, "0x01234567")
      out.should == str
    end

    it "should print for a class" do
      @ap.send(:awesome, MongoUser).should == <<-EOS.strip
class MongoUser < Object {
           "_id" => :object_id,
    "first_name" => :string,
     "last_name" => :string
}
EOS
    end

    it "should print for a class when type is undefined" do
      class Chamelion
        include MongoMapper::Document
        key :last_attribute
      end

      @ap.send(:awesome, Chamelion).should == <<-EOS.strip
class Chamelion < Object {
               "_id" => :object_id,
    "last_attribute" => :undefined
}
EOS
    end
  end

rescue LoadError
  puts "Skipping MongoMapper specs..."
end
