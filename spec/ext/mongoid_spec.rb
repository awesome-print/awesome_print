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

    after :all do
      Object.instance_eval{ remove_const :MongoUser }
      Object.instance_eval{ remove_const :Chamelion }
    end

    before do
      stub_dotfile!
      @ap = AwesomePrint::Inspector.new :plain => true, :sort_keys => true
    end

    it "should print class instance" do
      user = MongoUser.new :first_name => "Al", :last_name => "Capone"
      out = @ap.send :awesome, user

      object_id = user.id.inspect
      str = <<-EOS.strip
#<MongoUser:0x01234567> {
           :_id => #{object_id},
    :first_name => "Al",
     :last_name => "Capone"
}
EOS
      out.gsub!(/0x([a-f\d]+)/, "0x01234567")
      expect(out).to eq(str)
    end

    it "should print the class" do
      expect(@ap.send(:awesome, MongoUser)).to eq <<-EOS.strip
class MongoUser < Object {
           :_id => :"bson/object_id",
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

      last_attribute = defined?(::Moped) ? 'object' : '"mongoid/fields/serializable/object"'
      expect(@ap.send(:awesome, Chamelion)).to eq <<-EOS.strip
class Chamelion < Object {
               :_id => :"bson/object_id",
    :last_attribute => :#{last_attribute}
}
EOS
    end
  end

rescue LoadError => error
  puts "Skipping Mongoid specs: #{error}"
end
