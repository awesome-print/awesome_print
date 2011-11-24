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
#<MongoUser:0x01234567
          attr_accessor :attributes = {
               "_id" => #<BSON::ObjectId:0x01234567
            attr_accessor :data = [
                [ 0] 42,
                [ 1] 42,
                [ 2] 42,
                [ 3] 42,
                [ 4] 42,
                [ 5] 42,
                [ 6] 42,
                [ 7] 42,
                [ 8] 42,
                [ 9] 42,
                [10] 42,
                [11] 42
            ]
        >,
        "first_name" => "Al",
         "last_name" => "Capone"
    },
          attr_accessor :new_record = true,
    attr_reader :changed_attributes = {
               "_id" => nil,
        "first_name" => nil,
         "last_name" => nil
    },
        attr_reader :pending_nested = {},
     attr_reader :pending_relations = {}
>
EOS
      out.gsub!(/0x([a-f\d]+)/, "0x01234567")
      out.gsub!(/(\[\s?\d+\])\s\d+/, "\\1 42")
      out.should eq str
    end

    it "should print the class" do
      @ap.send(:awesome, MongoUser).should == <<-EOS.strip
class MongoUser < Object {
           "_id" => :"bson/object_id",
         "_type" => :string,
    "first_name" => :string,
     "last_name" => :string
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
               "_id" => :"bson/object_id",
             "_type" => :string,
    "last_attribute" => :"mongoid/fields/serializable/object"
}
EOS
    end
  end

rescue LoadError => error
  puts "Skipping Mongoid specs: #{error}"
end
