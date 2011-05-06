require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "AwesomePrint" do
  before(:each) do
    stub_dotfile!
  end

  describe "colorization" do
    PLAIN = '[ 1, :two, "three", [ nil, [ true, false ] ] ]'
    COLORIZED = "[ \e[1;34m1\e[0m, \e[0;36m:two\e[0m, \e[0;33m\"three\"\e[0m, [ \e[1;31mnil\e[0m, [ \e[1;32mtrue\e[0m, \e[1;31mfalse\e[0m ] ] ]"

    before(:each) do
      AwesomePrint.force_colors!(false)
      ENV['TERM'] = "xterm-colors"
      ENV.delete('ANSICON')
      @arr = [ 1, :two, "three", [ nil, [ true, false] ] ]
    end
    
    it "colorizes tty processes by default" do
      stub_tty!(STDOUT, true)

      @arr.ai(:multiline => false).should == COLORIZED
    end

    it "colorizes tty processes by default" do
      stub_tty!(STDOUT, true)

      @arr.ai(:multiline => false).should == COLORIZED
    end

    
    it "colorizes processes with ENV['ANSICON'] by default" do
      stub_tty!(STDOUT, true)
      ENV['ANSICON'] = "1"

      @arr.ai(:multiline => false).should == COLORIZED
    end

    it "does not colorize tty processes running in dumb terminals by default" do
      stub_tty!(STDOUT, true)
      ENV['TERM'] = "dumb"

      @arr.ai(:multiline => false).should == PLAIN
    end

    it "does not colorize subprocesses by default" do
      stub_tty!(STDOUT, false)

      @arr.ai(:multiline => false).should == PLAIN
    end
    
    describe "forced" do
      before(:each) do
        AwesomePrint.force_colors!
      end
      
      it "still colorizes tty processes" do
        stub_tty!(STDOUT, true)

        @arr.ai(:multiline => false).should == COLORIZED
      end
      
      it "colorizes dumb terminals" do
        stub_tty!(STDOUT, true)
        ENV["TERM"] = "dumb"

        @arr.ai(:multiline => false).should == COLORIZED
      end

      it "colorizes subprocess" do
        stub_tty!(STDOUT, true)
        @arr.ai(:multiline => false).should == COLORIZED
      end
    end
  end
  
  def stub_tty!(stream, value)
    eval(%{class << stream
      def tty?
        #{value}
      end
    end})
  end
end