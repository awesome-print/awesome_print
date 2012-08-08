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

      if defined?(::Moped)
        str = <<-EOS.strip
#<MongoUser:0x01234567> {
           :_id => "424242424242424242424242",
    :first_name => "Al",
     :last_name => "Capone"
}
EOS
      else
        str = <<-EOS.strip
#<MongoUser:0x01234567> {
           :_id => BSON::ObjectId('424242424242424242424242'),
    :first_name => "Al",
     :last_name => "Capone"
}
EOS
      end
      out.gsub!(/0x([a-f\d]+)/, "0x01234567")
      if defined?(::Moped)
        out.gsub!(/:_id => \"[^"]+/, ":_id => \"424242424242424242424242")
      else
        out.gsub!(/Id\('[^']+/, "Id('424242424242424242424242")
      end
      out.should == str
    end

    it "should print the class" do
      moped_or_not = defined?(::Moped) ? 'moped/' : ''
      @ap.send(:awesome, MongoUser).should == <<-EOS.strip
class MongoUser < Object {
           :_id => :"#{moped_or_not}bson/object_id",
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

      moped_or_not = defined?(::Moped) ? 'moped/' : ''
      last_attribute = defined?(::BSON) ? '"mongoid/fields/serializable/object"' : 'object'
      @ap.send(:awesome, Chamelion).should == <<-EOS.strip
class Chamelion < Object {
               :_id => :"#{moped_or_not}bson/object_id",
             :_type => :string,
    :last_attribute => :#{last_attribute}
}
EOS
    end
  end

rescue LoadError => error
  puts "Skipping Mongoid specs: #{error}"
end
