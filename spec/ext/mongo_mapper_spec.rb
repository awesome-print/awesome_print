require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

begin
  require "mongo_mapper"
  require "awesome_print/ext/mongo_mapper"

  describe "AwesomePrint/MongoMapper" do
    before :all do
      class MongoUser
        include MongoMapper::Document

        key :first_name, String
        key :last_name, String
      end
    end

    after :all do
      Object.instance_eval{ remove_const :MongoUser }
      Object.instance_eval{ remove_const :Chamelion }
    end

    before do
      stub_dotfile!
      @ap = AwesomePrint::Inspector.new(:plain => true, :sort_keys => true)
    end

    it "should print class instance" do
      user = MongoUser.new(:first_name => "Al", :last_name => "Capone")
      out = @ap.send(:awesome, user)
      str = <<-EOS.strip
#<MongoUser:0x01234567
    @_new = true,
    attr_accessor :first_name = "Al",
    attr_accessor :last_name = "Capone",
    attr_reader :changed_attributes = {
        "first_name" => nil,
         "last_name" => nil
    },
    attr_reader :first_name_before_type_cast = "Al",
    attr_reader :last_name_before_type_cast = "Capone"
>
EOS
      out.gsub!(/0x([a-f\d]+)/, "0x01234567")
      out.should == str
    end

    it "should print the class" do
      @ap.send(:awesome, MongoUser).should == <<-EOS.strip
class MongoUser < Object {
           "_id" => :object_id,
    "first_name" => :string,
     "last_name" => :string
}
EOS
    end

    it "should print the class when type is undefined" do
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

rescue LoadError => error
  puts "Skipping MongoMapper specs: #{error}"
end
