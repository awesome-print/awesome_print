require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

if defined?(::Rails)

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
  end

  describe "AwesomePrint/Rails" do
    before(:each) do
      stub_dotfile!
    end

    #------------------------------------------------------------------------------
    describe "ActiveRecord instance" do
      before(:each) do
        @diana = User.new(:name => "Diana", :rank => 1, :admin => false, :created_at => "1992-10-10 12:30:00")
        @laura = User.new(:name => "Laura", :rank => 2, :admin => true,  :created_at => "2003-05-26 14:15:00")
        @ap = AwesomePrint.new(:plain => true)
      end

      it "display single record" do
        out = @ap.send(:awesome, @diana)
        out.gsub(/0x([a-f\d]+)/, "0x01234567").should == <<-EOS.strip
#<User:0x01234567> {
            :id => nil,
          :name => "Diana",
          :rank => 1,
         :admin => false,
    :created_at => Sat, 10 Oct 1992 12:30:00 UTC +00:00
}
EOS
      end

      it "display multiple records" do
        out = @ap.send(:awesome, [ @diana, @laura ])
        out.gsub(/0x([a-f\d]+)/, "0x01234567").should == <<-EOS.strip
[
    [0] #<User:0x01234567> {
                :id => nil,
              :name => "Diana",
              :rank => 1,
             :admin => false,
        :created_at => Sat, 10 Oct 1992 12:30:00 UTC +00:00
    },
    [1] #<User:0x01234567> {
                :id => nil,
              :name => "Laura",
              :rank => 2,
             :admin => true,
        :created_at => Mon, 26 May 2003 14:15:00 UTC +00:00
    }
]
EOS
      end
    end

    #------------------------------------------------------------------------------
    describe "ActiveRecord class" do
      it "should" do
        @ap = AwesomePrint.new(:plain => true)
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
    end
  end
end
