require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

begin
  require 'active_support'
  require 'awesome_print/ext/active_support'

  describe "AwesomePrint::ActiveSupport" do
    before do
      stub_dotfile!
      @ap = AwesomePrint::Inspector.new
    end

    it "should format ActiveSupport::TimeWithZone as regular Time" do
      Time.zone = 'Eastern Time (US & Canada)'
      time = Time.utc(2007, 2, 10, 20, 30, 45).in_time_zone
      @ap.send(:awesome, time).should == "\e[0;32mSat, 10 Feb 2007 15:30:45 EST -05:00\e[0m"
    end

    it "should format HashWithIndifferentAccess as regular Hash" do
      hash = HashWithIndifferentAccess.new({ :hello => "world" })
      @ap.send(:awesome, hash).should == "{\n    \"hello\"\e[0;37m => \e[0m\e[0;33m\"world\"\e[0m\n}"
    end

    # ActiveSupport sticks in instance variables to the date object. Make sure
    # we ignore that and format Date instance as regular date.
    it "should formate Date object as date" do
      date = Date.new(2003, 5, 26)
      date.ai(:plain => true).should == "Mon, 26 May 2003"
      date.ai.should == "\e[0;32mMon, 26 May 2003\e[0m"
    end
  end

rescue LoadError => error
  puts "Skipping ActiveSupport specs: #{error}"
end
