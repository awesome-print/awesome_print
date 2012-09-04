require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "AwesomePrint" do
  before do
    stub_dotfile!
  end

  #------------------------------------------------------------------------------
  describe "Misc" do
    it "handle weird objects that return nil on inspect" do
      weird = Class.new do
        def inspect
          nil
        end
      end
      weird.new.ai(:plain => true).should == ''
    end

    it "handle frozen object.inspect" do
      weird = Class.new do
        def inspect
          "ice".freeze
        end
      end
      weird.new.ai(:plain => false).should == "ice"
    end

    # See https://github.com/michaeldv/awesome_print/issues/35
    it "handle array grep when pattern contains / chapacter" do
      hash = { "1/x" => 1,  "2//x" => :"2" }
      grepped = hash.keys.sort.grep(/^(\d+)\//) { $1 }
      grepped.ai(:plain => true, :multiline => false).should == '[ "1", "2" ]'
    end

    # See https://github.com/michaeldv/awesome_print/issues/85
    if RUBY_VERSION >= "1.8.7"
      it "handle array grep when a method is defined in C and thus doesn't have a binding" do
        arr = (0..6).to_a
        grepped = arr.grep(1..4, &:succ)
        grepped.ai(:plain => true, :multiline => false).should == '[ 2, 3, 4, 5 ]'
      end
    end

    it "returns value passed as a parameter" do
      object = rand
      self.stub!(:puts)
      (ap object).should == object
    end

    # Require different file name this time (lib/ap.rb vs. lib/awesome_print).
    it "several require 'awesome_print' should do no harm" do
      require File.expand_path(File.dirname(__FILE__) + '/../lib/ap')
      lambda { rand.ai }.should_not raise_error
    end
  end

  describe "HTML output" do
    it "wraps ap output with plain <pre> tag" do
      markup = rand
      markup.ai(:html => true, :plain => true).should == "<pre>#{markup}</pre>"
    end

    it "wraps ap output with <pre> tag with colorized <kbd>" do
      markup = rand
      markup.ai(:html => true).should == %Q|<pre><kbd style="color:blue">#{markup}</kbd></pre>|
    end

    it "wraps multiline ap output with <pre> tag with colorized <kbd>" do
      markup = [ 1, :two, "three" ]
      markup.ai(:html => true).should == <<-EOS.strip
<pre>[
    <kbd style="color:white">[0] </kbd><pre><kbd style="color:blue">1</kbd></pre>,
    <kbd style="color:white">[1] </kbd><pre><kbd style="color:darkcyan">:two</kbd></pre>,
    <kbd style="color:white">[2] </kbd><pre><kbd style="color:brown">&quot;three&quot;</kbd></pre>
]</pre>
EOS
    end

    it "encodes HTML entities (plain)" do
      markup = ' &<hello>'
      markup.ai(:html => true, :plain => true).should == '<pre>&quot; &amp;&lt;hello&gt;&quot;</pre>'
    end

    it "encodes HTML entities (color)" do
      markup = ' &<hello>'
      markup.ai(:html => true).should == '<pre><kbd style="color:brown">&quot; &amp;&lt;hello&gt;&quot;</kbd></pre>'
    end
  end

  describe "AwesomePrint.defaults" do
    # See https://github.com/michaeldv/awesome_print/issues/98
    it "should properly merge the defaults" do
      AwesomePrint.defaults = { :indent => -2, :sort_keys => true }
      hash = { [0, 0, 255] => :yellow, :red => "rgb(255, 0, 0)", "magenta" => "rgb(255, 0, 255)" }
      out = hash.ai(:plain => true)
      out.should == <<-EOS.strip
{
  [ 0, 0, 255 ] => :yellow,
  "magenta"     => "rgb(255, 0, 255)",
  :red          => "rgb(255, 0, 0)"
}
EOS
    end

    describe "Coexistence with the colorize gem" do
      before do # Redefine String#red just like colorize gem does it.
        @awesome_method = "".method(:red)
        String.instance_eval do
          define_method :red do   # Method arity is 0.
            "[red]#{self}[/red]"
          end
        end
      end

      after do # Restore String#red method.
        awesome_method = @awesome_method
        String.instance_eval do
          define_method :red, awesome_method
        end
      end

      it "shoud not raise ArgumentError when formatting HTML" do
        out = "hello".ai(:color => { :string => :red }, :html => true)
        out.should == %Q|<pre>[red]<kbd style="color:red">&quot;hello&quot;</kbd>[/red]</pre>|
      end

      it "shoud not raise ArgumentError when formatting HTML (shade color)" do
        out = "hello".ai(:color => { :string => :redish }, :html => true)
        out.should == %Q|<pre><kbd style="color:darkred">&quot;hello&quot;</kbd></pre>|
      end

      it "shoud not raise ArgumentError when formatting non-HTML" do
        out = "hello".ai(:color => { :string => :red }, :html => false)
        out.should == %Q|[red]"hello"[/red]|
      end

      it "shoud not raise ArgumentError when formatting non-HTML (shade color)" do
        out = "hello".ai(:color => { :string => :redish }, :html => false)
        out.should == %Q|\e[0;31m"hello"\e[0m|
      end
    end
  end
end
