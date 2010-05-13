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
      @struct.ai(:plain => true).should == <<-EOS.strip
{
    :address => "1313 Mockingbird Lane",
       :name => "Herman Munster"
}
EOS
    end

    it "plain multiline indented" do
      @struct.ai(:plain => true, :indent => 1).should == <<-EOS.strip
{
 :address => "1313 Mockingbird Lane",
    :name => "Herman Munster"
}
EOS
    end

    it "plain single line" do
      @struct.ai(:plain => true, :multiline => false).should == "{ :address => \"1313 Mockingbird Lane\", :name => \"Herman Munster\" }"
    end

    it "colored multiline (default)" do
      @struct.ai.should == <<-EOS.strip
{
    :address\e[0;37m => \e[0m\e[0;33m\"1313 Mockingbird Lane\"\e[0m,
       :name\e[0;37m => \e[0m\e[0;33m\"Herman Munster\"\e[0m
}
EOS
    end
  end


end
