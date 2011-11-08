require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

begin
  require 'active_record'
  require 'awesome_print/ext/active_record'

  # Create tableless ActiveRecord model.
  #------------------------------------------------------------------------------
  class User < ActiveRecord::Base
    def self.columns()
      @columns ||= []
    end

    def self.column(name, sql_type = nil, default = nil, null = true)
      columns << ActiveRecord::ConnectionAdapters::Column.new(name.to_s, default, sql_type.to_s, null)
    end

    column :id, :integer
    column :name, :string
    column :rank, :integer
    column :admin, :boolean
    column :created_at, :datetime

    def self.table_exists?
      true
    end
  end

  class SubUser < User
    def self.columns
      User.columns
    end
  end

  describe "AwesomePrint/ActiveRecord" do
    before do
      stub_dotfile!
    end

    #------------------------------------------------------------------------------
    describe "ActiveRecord instance" do
      before do
        ActiveRecord::Base.default_timezone = :utc
        @diana = User.new(:name => "Diana", :rank => 1, :admin => false, :created_at => "1992-10-10 12:30:00")
        @laura = User.new(:name => "Laura", :rank => 2, :admin => true,  :created_at => "2003-05-26 14:15:00")
        @ap = AwesomePrint::Inspector.new(:plain => true, :sort_keys => true)
      end

      it "display single record" do
        out = @ap.send(:awesome, @diana)
        str = <<-EOS.strip
#<User:0x01234567
                  @attributes_cache = {},
                         @destroyed = false,
            @marked_for_destruction = false,
                        @new_record = true,
                @previously_changed = {},
                          @readonly = false,
          attr_accessor :attributes = {
             "admin" => false,
        "created_at" => "?",
              "name" => "Diana",
              "rank" => 1
    },
    attr_reader :changed_attributes = {
             "admin" => nil,
        "created_at" => nil,
              "name" => nil,
              "rank" => nil
    }
>
EOS
        str.sub!('?', '1992-10-10 12:30:00')
        out.gsub(/0x([a-f\d]+)/, "0x01234567").should == str
      end

      it "display multiple records" do
        out = @ap.send(:awesome, [ @diana, @laura ])
        str = <<-EOS.strip
[
    [0] #<User:0x01234567
                      @attributes_cache = {},
                             @destroyed = false,
                @marked_for_destruction = false,
                            @new_record = true,
                    @previously_changed = {},
                              @readonly = false,
              attr_accessor :attributes = {
                 "admin" => false,
            "created_at" => "?",
                  "name" => "Diana",
                  "rank" => 1
        },
        attr_reader :changed_attributes = {
                 "admin" => nil,
            "created_at" => nil,
                  "name" => nil,
                  "rank" => nil
        }
    >,
    [1] #<User:0x01234567
                      @attributes_cache = {},
                             @destroyed = false,
                @marked_for_destruction = false,
                            @new_record = true,
                    @previously_changed = {},
                              @readonly = false,
              attr_accessor :attributes = {
                 "admin" => true,
            "created_at" => "?",
                  "name" => "Laura",
                  "rank" => 2
        },
        attr_reader :changed_attributes = {
                 "admin" => nil,
            "created_at" => nil,
                  "name" => nil,
                  "rank" => nil
        }
    >
]
EOS
        str.sub!('?', '1992-10-10 12:30:00')
        str.sub!('?', '2003-05-26 14:15:00')
        out.gsub(/0x([a-f\d]+)/, "0x01234567").should == str
      end
    end

    #------------------------------------------------------------------------------
    describe "ActiveRecord class" do
      before do
        @ap = AwesomePrint::Inspector.new(:plain => true)
      end

      it "should print the class" do
        @ap.send(:awesome, User).should == <<-EOS.strip
class User < ActiveRecord::Base {
            :id => :integer,
          :name => :string,
          :rank => :integer,
         :admin => :boolean,
    :created_at => :datetime
}
EOS
      end

      it "should print the class for non-direct subclasses of ActiveRecord::Base" do
        @ap.send(:awesome, SubUser).should == <<-EOS.strip
class SubUser < User {
            :id => :integer,
          :name => :string,
          :rank => :integer,
         :admin => :boolean,
    :created_at => :datetime
}
EOS
      end

      it "should print ActiveRecord::Base objects (ex. ancestors)" do
        lambda { @ap.send(:awesome, User.ancestors) }.should_not raise_error
      end
    end
  end

rescue LoadError
  puts "Skipping ActiveRecord specs..."
end
