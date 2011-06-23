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

    context "with associations" do
      before :all do
        class Child
          include MongoMapper::EmbeddedDocument
          key :data
        end

        class Sibling
          include MongoMapper::Document
          key :title
        end

        class Parent
          include MongoMapper::Document
          key :name

          one :child
          one :sibling
        end
      end

      context "with show associations turned off (default)" do
        it "should render the class as normal" do
          @ap.send(:awesome, Parent).should == <<-EOS.strip
class Parent < Object {
     "_id" => :object_id,
    "name" => :undefined
}
EOS
        end

        it "should render an instance as normal" do
          parent = Parent.new(:name => 'test')
          out = @ap.send(:awesome, parent)
          str = <<-EOS.strip
#<Parent:0x01234567> {
     "_id" => BSON::ObjectId('4d9183739a546f6806000001'),
    "name" => "test"
}
EOS
          out.gsub!(/'([\w]+){23}'/, "'4d9183739a546f6806000001'")
          out.gsub!(/0x([a-f\d]+)/, "0x01234567")
          out.should == str
        end
      end

      context "with show associations turned on and inline embedded turned off" do
        before :each do
          @ap = AwesomePrint.new(:plain => true,
                                 :mongo_mapper => {
                                   :show_associations => true })
        end

        it "should render the class with associations shown" do
          @ap.send(:awesome, Parent).should == <<-EOS.strip
class Parent < Object {
        "_id" => :object_id,
       "name" => :undefined,
      "child" => embeds one Child,
    "sibling" => one Sibling
}
EOS
        end

        it "should render an instance with associations shown" do
          parent = Parent.new(:name => 'test')
          out = @ap.send(:awesome, parent)
          str = <<-EOS.strip
#<Parent:0x01234567> {
        "_id" => BSON::ObjectId('4d9183739a546f6806000001'),
       "name" => "test",
      "child" => embeds one Child,
    "sibling" => one Sibling
}
EOS
          out.gsub!(/'([\w]+){23}'/, "'4d9183739a546f6806000001'")
          out.gsub!(/0x([a-f\d]+)/, "0x01234567")
          out.should == str
        end
      end

      context "with show associations turned on and inline embedded turned on" do
        before :each do
          @ap = AwesomePrint.new(:plain => true,
                                 :mongo_mapper => {
                                   :show_associations => true,
                                   :inline_embedded => true })
        end

        it "should render an instance with associations shown and embeds there" do
          parent = Parent.new(:name => 'test', :child => Child.new(:data => 5))
          out = @ap.send(:awesome, parent)
          str = <<-EOS.strip
#<Parent:0x01234567> {
        "_id" => BSON::ObjectId('4d9183739a546f6806000001'),
       "name" => "test",
      "child" => embedded #<Child:0x01234567> {
         "_id" => BSON::ObjectId('4d9183739a546f6806000001'),
        "data" => 5
    },
    "sibling" => one Sibling
}
EOS
          out.gsub!(/'([\w]+){23}'/, "'4d9183739a546f6806000001'")
          out.gsub!(/0x([a-f\d]+)/, "0x01234567")
          out.should == str
        end
      end
    end
  end

rescue LoadError
  puts "Skipping MongoMapper specs..."
end
