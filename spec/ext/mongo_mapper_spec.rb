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

    before do
      @ap = AwesomePrint::Inspector.new(:plain => true, :sort_keys => true)
    end

    it "should print class instance" do
      user = MongoUser.new(:first_name => "Al", :last_name => "Capone")
      out = @ap.send(:awesome, user)
      str = <<-EOS.strip
#<MongoUser:0x01234567
                                       @_new = true,
                          attr_accessor :_id = #<BSON::ObjectId:0x01234567
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
                   attr_accessor :first_name = "Al",
                    attr_accessor :last_name = "Capone",
           attr_reader :_id_before_type_cast = #<BSON::ObjectId:0x01234567
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
             attr_reader :changed_attributes = {
        "first_name" => nil,
         "last_name" => nil
    },
    attr_reader :first_name_before_type_cast = "Al",
     attr_reader :last_name_before_type_cast = "Capone"
>
EOS
      out.gsub!(/0x([a-f\d]+)/, "0x01234567")
      out.gsub!(/(\[\s?\d+\])\s\d+/, "\\1 42")
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

rescue LoadError
  puts "Skipping MongoMapper specs..."
end
