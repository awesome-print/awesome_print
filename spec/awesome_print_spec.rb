require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require "bigdecimal"
require "rational"

describe "AwesomePrint" do
  before(:each) do
    stub_dotfile!
  end

  describe "Array" do
    before(:each) do
      @arr = [ 1, :two, "three", [ nil, [ true, false] ] ]
    end

    it "empty array" do
      [].ai.should == "[]"
    end

    it "plain multiline" do
      @arr.ai(:plain => true).should == <<-EOS.strip
[
    [0] 1,
    [1] :two,
    [2] "three",
    [3] [
        [0] nil,
        [1] [
            [0] true,
            [1] false
        ]
    ]
]
EOS
      end

    it "plain multiline without index" do
      @arr.ai(:plain => true, :index => false).should == <<-EOS.strip
[
    1,
    :two,
    "three",
    [
        nil,
        [
            true,
            false
        ]
    ]
]
EOS
      end

    it "plain multiline indented" do
      @arr.ai(:plain => true, :indent => 2).should == <<-EOS.strip
[
  [0] 1,
  [1] :two,
  [2] "three",
  [3] [
    [0] nil,
    [1] [
      [0] true,
      [1] false
    ]
  ]
]
EOS
    end

    it "plain multiline indented without index" do
      @arr.ai(:plain => true, :indent => 2, :index => false).should == <<-EOS.strip
[
  1,
  :two,
  "three",
  [
    nil,
    [
      true,
      false
    ]
  ]
]
EOS
    end

    it "plain single line" do
      @arr.ai(:plain => true, :multiline => false).should == '[ 1, :two, "three", [ nil, [ true, false ] ] ]'
    end

    it "colored multiline (default)" do
      @arr.ai.should == <<-EOS.strip
[
\e[1;37m    [0] \e[0m\e[1;34m1\e[0m,
\e[1;37m    [1] \e[0m\e[0;36m:two\e[0m,
\e[1;37m    [2] \e[0m\e[0;33m\"three\"\e[0m,
\e[1;37m    [3] \e[0m[
\e[1;37m        [0] \e[0m\e[1;31mnil\e[0m,
\e[1;37m        [1] \e[0m[
\e[1;37m            [0] \e[0m\e[1;32mtrue\e[0m,
\e[1;37m            [1] \e[0m\e[1;31mfalse\e[0m
        ]
    ]
]
EOS
      end

    it "colored multiline indented" do
      @arr.ai(:indent => 8).should == <<-EOS.strip
[
\e[1;37m        [0] \e[0m\e[1;34m1\e[0m,
\e[1;37m        [1] \e[0m\e[0;36m:two\e[0m,
\e[1;37m        [2] \e[0m\e[0;33m\"three\"\e[0m,
\e[1;37m        [3] \e[0m[
\e[1;37m                [0] \e[0m\e[1;31mnil\e[0m,
\e[1;37m                [1] \e[0m[
\e[1;37m                        [0] \e[0m\e[1;32mtrue\e[0m,
\e[1;37m                        [1] \e[0m\e[1;31mfalse\e[0m
                ]
        ]
]
EOS
    end

    it "colored single line" do
      @arr.ai(:multiline => false).should == "[ \e[1;34m1\e[0m, \e[0;36m:two\e[0m, \e[0;33m\"three\"\e[0m, [ \e[1;31mnil\e[0m, [ \e[1;32mtrue\e[0m, \e[1;31mfalse\e[0m ] ] ]"
    end
  end

  #------------------------------------------------------------------------------
  describe "Nested Array" do
    before(:each) do
      @arr = [ 1, 2 ]
      @arr << @arr
    end

    it "plain multiline" do
      @arr.ai(:plain => true).should == <<-EOS.strip
[
    [0] 1,
    [1] 2,
    [2] [...]
]
EOS
    end

    it "plain multiline without index" do
      @arr.ai(:plain => true, :index => false).should == <<-EOS.strip
[
    1,
    2,
    [...]
]
EOS
    end

    it "plain single line" do
      @arr.ai(:plain => true, :multiline => false).should == "[ 1, 2, [...] ]"
    end
  end

  #------------------------------------------------------------------------------
  describe "Hash" do
    before(:each) do
      @hash = { 1 => { :sym => { "str" => { [1, 2, 3] => { { :k => :v } => Hash } } } } }
    end
    
    it "empty hash" do
      {}.ai.should == "{}"
    end
    
    it "plain multiline" do
      @hash.ai(:plain => true).should == <<-EOS.strip
{
    1 => {
        :sym => {
            "str" => {
                [ 1, 2, 3 ] => {
                    { :k => :v } => Hash < Object
                }
            }
        }
    }
}
EOS
    end

    it "plain multiline indented" do
      @hash.ai(:plain => true, :indent => 1).should == <<-EOS.strip
{
 1 => {
  :sym => {
   "str" => {
    [ 1, 2, 3 ] => {
     { :k => :v } => Hash < Object
    }
   }
  }
 }
}
EOS
    end

    it "plain single line" do
      @hash.ai(:plain => true, :multiline => false).should == '{ 1 => { :sym => { "str" => { [ 1, 2, 3 ] => { { :k => :v } => Hash < Object } } } } }'
    end

    it "colored multiline (default)" do
      @hash.ai.should == <<-EOS.strip
{
    1\e[0;37m => \e[0m{
        :sym\e[0;37m => \e[0m{
            \"str\"\e[0;37m => \e[0m{
                [ 1, 2, 3 ]\e[0;37m => \e[0m{
                    { :k => :v }\e[0;37m => \e[0m\e[1;33mHash < Object\e[0m
                }
            }
        }
    }
}
EOS
    end

    it "colored multiline indented" do
      @hash.ai(:indent => 2).should == <<-EOS.strip
{
  1\e[0;37m => \e[0m{
    :sym\e[0;37m => \e[0m{
      \"str\"\e[0;37m => \e[0m{
        [ 1, 2, 3 ]\e[0;37m => \e[0m{
          { :k => :v }\e[0;37m => \e[0m\e[1;33mHash < Object\e[0m
        }
      }
    }
  }
}
EOS
    end

    it "colored single line" do
      @hash.ai(:multiline => false).should == "{ 1\e[0;37m => \e[0m{ :sym\e[0;37m => \e[0m{ \"str\"\e[0;37m => \e[0m{ [ 1, 2, 3 ]\e[0;37m => \e[0m{ { :k => :v }\e[0;37m => \e[0m\e[1;33mHash < Object\e[0m } } } } }"
    end

  end

  #------------------------------------------------------------------------------
  describe "Nested Hash" do
    before(:each) do
      @hash = {}
      @hash[:a] = @hash
    end

    it "plain multiline" do
      @hash.ai(:plain => true).should == <<-EOS.strip
{
    :a => {...}
}
EOS
    end

    it "plain single line" do
      @hash.ai(:plain => true, :multiline => false).should == '{ :a => {...} }'
    end
  end

  #------------------------------------------------------------------------------
  describe "Hash with several keys" do
    before(:each) do
      @hash = {"b" => "b", :a => "a", :z => "z", "alpha" => "alpha"}
    end

    it "plain multiline" do
      out = @hash.ai(:plain => true)
      if RUBY_VERSION.to_f < 1.9 # Order of @hash keys is not guaranteed.
        out.should =~ /^\{[^\}]+\}/m
        out.should =~ /        "b" => "b",?/
        out.should =~ /         :a => "a",?/
        out.should =~ /         :z => "z",?/
        out.should =~ /    "alpha" => "alpha",?$/
      else
        out.should == <<-EOS.strip
{
        "b" => "b",
         :a => "a",
         :z => "z",
    "alpha" => "alpha"
}
EOS
      end
    end
    
    it "plain multiline with sorted keys" do
      @hash.ai(:plain => true, :sorted_hash_keys => true).should == <<-EOS.strip
{
         :a => "a",
    "alpha" => "alpha",
        "b" => "b",
         :z => "z"
}
EOS
    end

  end

  #------------------------------------------------------------------------------
  describe "Negative options[:indent]" do
    before(:each) do
      @hash = { [0, 0, 255] => :yellow, :red => "rgb(255, 0, 0)", "magenta" => "rgb(255, 0, 255)" }
    end

    it "hash keys must be left aligned" do
      out = @hash.ai(:plain => true, :indent => -4)
      out.start_with?("{\n").should == true
      out.include?('    :red          => "rgb(255, 0, 0)"').should == true
      out.include?('    "magenta"     => "rgb(255, 0, 255)"').should == true
      out.include?('    [ 0, 0, 255 ] => :yellow').should == true
      out.end_with?("\n}").should == true
    end
  end

  #------------------------------------------------------------------------------
  describe "Class" do
    it "shoud show superclass (plain)" do
      self.class.ai(:plain => true).should == "#{self.class} < #{self.class.superclass}"
    end

    it "shoud show superclass (color)" do
      self.class.ai.should == "#{self.class} < #{self.class.superclass}".yellow
    end
  end

  #------------------------------------------------------------------------------
  describe "File" do
    it "should display a file (plain)" do
      File.open(__FILE__, "r") do |f|
        f.ai(:plain => true).should == "#{f.inspect}\n" << `ls -alF #{f.path}`.chop
      end
    end
  end

  #------------------------------------------------------------------------------
  describe "Dir" do
    it "should display a direcory (plain)" do
      Dir.open(File.dirname(__FILE__)) do |d|
        d.ai(:plain => true).should == "#{d.inspect}\n" << `ls -alF #{d.path}`.chop
      end
    end
  end

  #------------------------------------------------------------------------------
  describe "BigDecimal and Rational" do
    it "should present BigDecimal object as Float scalar" do
      big = BigDecimal("2010.4")
      big.ai(:plain => true).should == "2010.4"
    end

    it "should present Rational object as Float scalar" do
      rat = Rational(2010, 2)
      rat.ai(:plain => true).should == "1005.0"
    end
  end

  #------------------------------------------------------------------------------
  describe "Utility methods" do
    it "should merge options" do
      ap = AwesomePrint.new
      ap.send(:merge_options!, { :color => { :array => :black }, :indent => 0 })
      options = ap.instance_variable_get("@options")
      options[:color][:array].should == :black
      options[:indent].should == 0
    end
  end


  #------------------------------------------------------------------------------
  describe "Struct" do
    before(:each) do
      @struct = unless defined?(Struct::SimpleStruct)
        Struct.new("SimpleStruct", :name, :address).new
      else
        Struct::SimpleStruct.new
      end
      @struct.name = "Herman Munster"
      @struct.address = "1313 Mockingbird Lane"
    end
    
    it "empty struct" do
      Struct.new("EmptyStruct").ai.should ==  "\e[1;33mStruct::EmptyStruct < Struct\e[0m"
    end
    
    it "plain multiline" do
      s1 = <<-EOS.strip
{
    :address => "1313 Mockingbird Lane",
       :name => "Herman Munster"
}
EOS
      s2 = <<-EOS.strip
{
       :name => "Herman Munster",
    :address => "1313 Mockingbird Lane"
}
EOS
      @struct.ai(:plain => true).should satisfy { |match| match == s1 || match == s2 }
    end

    it "plain multiline indented" do
      s1 = <<-EOS.strip
{
 :address => "1313 Mockingbird Lane",
    :name => "Herman Munster"
}
EOS
      s2 = <<-EOS.strip
{
    :name => "Herman Munster",
 :address => "1313 Mockingbird Lane"
}
EOS
      @struct.ai(:plain => true, :indent => 1).should satisfy { |match| match == s1 || match == s2 }
    end

    it "plain single line" do
      s1 = "{ :address => \"1313 Mockingbird Lane\", :name => \"Herman Munster\" }"
      s2 = "{ :name => \"Herman Munster\", :address => \"1313 Mockingbird Lane\" }"
      @struct.ai(:plain => true, :multiline => false).should satisfy { |match| match == s1 || match == s2 }
    end

    it "colored multiline (default)" do
      s1 = <<-EOS.strip
{
    :address\e[0;37m => \e[0m\e[0;33m\"1313 Mockingbird Lane\"\e[0m,
       :name\e[0;37m => \e[0m\e[0;33m\"Herman Munster\"\e[0m
}
EOS
      s2 = <<-EOS.strip
{
       :name\e[0;37m => \e[0m\e[0;33m\"Herman Munster\"\e[0m,
    :address\e[0;37m => \e[0m\e[0;33m\"1313 Mockingbird Lane\"\e[0m
}
EOS
      @struct.ai.should satisfy { |match| match == s1 || match == s2 }
    end
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

    # See https://github.com/michaeldv/awesome_print/issues/35
    it "handle array grep when pattern contains / chapacter" do
      hash = { "1/x" => 1,  "2//x" => :"2" }
      grepped = hash.keys.grep(/^(\d+)\//) { $1 }
      grepped.ai(:plain => true, :multiline => false).should == '[ "1", "2" ]'
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

    it "wraps ap output with colorized <pre> tag" do
      markup = rand
      markup.ai(:html => true).should == %Q|<pre style="color:blue">#{markup}</pre>|
    end

    it "encodes HTML entities (plain)" do
      markup = ' &<hello>'
      markup.ai(:html => true, :plain => true).should == '<pre>&quot; &amp;&lt;hello&gt;&quot;</pre>'
    end

    it "encodes HTML entities (color)" do
      markup = ' &<hello>'
      markup.ai(:html => true).should == '<pre style="color:brown">&quot; &amp;&lt;hello&gt;&quot;</pre>'
    end
  end

  #------------------------------------------------------------------------------
  describe "Inherited from standard Ruby classes" do
    after do
      Object.instance_eval{ remove_const :My } if defined?(My)
    end

    it "inherited from Array should be displayed as Array" do
      class My < Array; end

      my = My.new([ 1, :two, "three", [ nil, [ true, false ] ] ])
      my.ai(:plain => true).should == <<-EOS.strip
[
    [0] 1,
    [1] :two,
    [2] "three",
    [3] [
        [0] nil,
        [1] [
            [0] true,
            [1] false
        ]
    ]
]
EOS
    end

    it "inherited from Hash should be displayed as Hash" do
      class My < Hash; end

      my = My[ { 1 => { :sym => { "str" => { [1, 2, 3] => { { :k => :v } => Hash } } } } } ]
      my.ai(:plain => true).should == <<-EOS.strip
{
    1 => {
        :sym => {
            "str" => {
                [ 1, 2, 3 ] => {
                    { :k => :v } => Hash < Object
                }
            }
        }
    }
}
EOS
    end

    it "inherited from File should be displayed as File" do
      class My < File; end

      my = File.new('/dev/null') rescue File.new('nul')
      my.ai(:plain => true).should == "#{my.inspect}\n" << `ls -alF #{my.path}`.chop
    end

    it "inherited from Dir should be displayed as Dir" do
      class My < Dir; end

      require 'tmpdir'
      my = My.new(Dir.tmpdir)
      my.ai(:plain => true).should == "#{my.inspect}\n" << `ls -alF #{my.path}`.chop
    end

    it "should handle a class that defines its own #send method" do
      class My
        def send(arg1, arg2, arg3); end
      end

      my = My.new
      my.methods.ai(:plain => true).should_not raise_error(ArgumentError)
    end

    it "should handle a class defines its own #method method (ex. request.method)" do
      class My
        def method
          'POST'
        end
      end

      my = My.new
      my.methods.ai(:plain => true).should_not raise_error(ArgumentError)
    end
  end
end
