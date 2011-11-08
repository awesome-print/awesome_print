require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "AwesomePrint" do
  def stub_tty!(output = true, stream = STDOUT)
    if output
      stream.instance_eval { def tty?;  true; end }
    else
      stream.instance_eval { def tty?; false; end }
    end
  end

  before do
    stub_dotfile!
  end

  describe "colorization" do
    PLAIN = '[ 1, :two, "three", [ nil, [ true, false ] ] ]'
    COLORIZED = "[ \e[1;34m1\e[0m, \e[0;36m:two\e[0m, \e[0;33m\"three\"\e[0m, [ \e[1;31mnil\e[0m, [ \e[1;32mtrue\e[0m, \e[1;31mfalse\e[0m ] ] ]"

    before do
      ENV['TERM'] = "xterm-colors"
      ENV.delete('ANSICON')
      @arr = [ 1, :two, "three", [ nil, [ true, false] ] ]
    end

    describe "default settings (no forced colors)" do
      before do
        AwesomePrint.force_colors! false
      end

      it "colorizes tty processes by default" do
        stub_tty!
        @arr.ai(:multiline => false).should == COLORIZED
      end

      it "colorizes processes with ENV['ANSICON'] by default" do
        begin
          stub_tty!
          term, ENV['ANSICON'] = ENV['ANSICON'], "1"
          @arr.ai(:multiline => false).should == COLORIZED
        ensure
          ENV['ANSICON'] = term
        end
      end

      it "does not colorize tty processes running in dumb terminals by default" do
        begin
          stub_tty!
          term, ENV['TERM'] = ENV['TERM'], "dumb"
          @arr.ai(:multiline => false).should == PLAIN
        ensure
          ENV['TERM'] = term
        end
      end

      it "does not colorize subprocesses by default" do
        begin
          stub_tty! false
          @arr.ai(:multiline => false).should == PLAIN
        ensure
          stub_tty!
        end
      end
    end

    describe "forced colors override" do
      before do
        AwesomePrint.force_colors!
      end
      
      it "still colorizes tty processes" do
        stub_tty!
        @arr.ai(:multiline => false).should == COLORIZED
      end

      it "colorizes processes with ENV['ANSICON'] set to 0" do
        begin
          stub_tty!
          term, ENV['ANSICON'] = ENV['ANSICON'], "1"
          @arr.ai(:multiline => false).should == COLORIZED
        ensure
          ENV['ANSICON'] = term
        end
      end
      
      it "colorizes dumb terminals" do
        begin
          stub_tty!
          term, ENV['TERM'] = ENV['TERM'], "dumb"
          @arr.ai(:multiline => false).should == COLORIZED
        ensure
          ENV['TERM'] = term
        end
      end

      it "colorizes subprocess" do
        begin
          stub_tty! false
          @arr.ai(:multiline => false).should == COLORIZED
        ensure
          stub_tty!
        end
      end
    end
  end
end
