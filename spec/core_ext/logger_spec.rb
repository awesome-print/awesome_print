require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')


require 'logger'
require 'awesome_print/core_ext/logger'

describe "AwesomePrint logging extensions" do
  before(:all) do
    @logger = Logger.new('/dev/null') rescue Logger.new('nul')
  end

  describe "ap method" do
    it "should awesome_inspect the given object" do
      object = mock
      object.should_receive(:ai)
      @logger.ap object
    end
    
    describe "the log level" do
      before do
        AwesomePrint.defaults = {}
      end
      
      it "should fallback to the default :debug log level" do
        @logger.should_receive(:debug)
        @logger.ap(nil)
      end

      it "should use the global user default if no level passed" do
        AwesomePrint.defaults = { :log_level => :info }
        @logger.should_receive(:info)
        @logger.ap(nil)
      end

      it "should use the passed in level" do
        @logger.should_receive(:warn)
        @logger.ap(nil, :warn)
      end
    end
  end
end


