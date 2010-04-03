require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "AwesomePrint" do
  before(:each) do
    @color_ap = AwesomePrint.new
    @plain_ap = AwesomePrint.new(:plain => true)
  end

  #------------------------------------------------------------------------------
  describe "Array" do
    before(:each) do
      @arr = [ 1, :two, "three", [ nil, [ true, false] ] ]
    end

    it "plain multiline" do
      ap = AwesomePrint.new(:plain => true)
      ap.send(:awesome, @arr).should == <<-EOS.strip
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
      ap = AwesomePrint.new(:plain => true, :indent => 2)
      ap.send(:awesome, @arr).should == <<-EOS.strip
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
      ap = AwesomePrint.new(:plain => true, :multiline => false)
      ap.send(:awesome, @arr).should == '[ 1, :two, "three", [ nil, [ true, false ] ] ]'
    end

    it "colored multiline" do
      ap = AwesomePrint.new
      ap.send(:awesome, @arr).should == <<-EOS.strip
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
      ap = AwesomePrint.new(:indent => 8)
      ap.send(:awesome, @arr).should == <<-EOS.strip
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
      ap = AwesomePrint.new(:multiline => false)
      ap.send(:awesome, @arr).should == "[ \e[1;34m1\e[0m, \e[0;36m:two\e[0m, \e[0;33m\"three\"\e[0m, [ \e[1;31mnil\e[0m, [ \e[1;32mtrue\e[0m, \e[1;31mfalse\e[0m ] ] ]"
    end
  end

  #------------------------------------------------------------------------------
  describe "Nested Array" do
    before(:each) do
      @arr = [ 1, 2 ]
      @arr << @arr
    end

    it "plain multiline" do
      ap = AwesomePrint.new(:plain => true)
      ap.send(:awesome, @arr).should == <<-EOS.strip
[
    [0] 1,
    [1] 2,
    [2] [...]
]
EOS
    end

    it "plain single line" do
      ap = AwesomePrint.new(:plain => true, :multiline => false)
      ap.send(:awesome, @arr).should == "[ 1, 2, [...] ]"
    end
  end

  #------------------------------------------------------------------------------
  describe "Hash" do
    before(:each) do
      @hash = { 1 => { :sym => { "str" => { [1, 2, 3] => { { :k => :v } => Hash } } } } }
    end

    it "plain multiline" do
      ap = AwesomePrint.new(:plain => true)
      ap.send(:awesome, @hash).should == <<-EOS.strip
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
      ap = AwesomePrint.new(:plain => true, :indent => 1)
      ap.send(:awesome, @hash).should == <<-EOS.strip
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
      ap = AwesomePrint.new(:plain => true, :multiline => false)
      ap.send(:awesome, @hash).should == '{ 1 => { :sym => { "str" => { [ 1, 2, 3 ] => { { :k => :v } => Hash < Object } } } } }'
    end

    it "colored multiline" do
      ap = AwesomePrint.new
      ap.send(:awesome, @hash).should == <<-EOS.strip
{
    1\e[1;30m => \e[0m{
        :sym\e[1;30m => \e[0m{
            \"str\"\e[1;30m => \e[0m{
                [ 1, 2, 3 ]\e[1;30m => \e[0m{
                    { :k => :v }\e[1;30m => \e[0m\e[1;33mHash < Object\e[0m
                }
            }
        }
    }
}
EOS
    end

    it "colored multiline indented" do
      ap = AwesomePrint.new(:indent => 2)
      ap.send(:awesome, @hash).should == <<-EOS.strip
{
  1\e[1;30m => \e[0m{
    :sym\e[1;30m => \e[0m{
      \"str\"\e[1;30m => \e[0m{
        [ 1, 2, 3 ]\e[1;30m => \e[0m{
          { :k => :v }\e[1;30m => \e[0m\e[1;33mHash < Object\e[0m
        }
      }
    }
  }
}
EOS
    end

    it "colored single line" do
      ap = AwesomePrint.new(:multiline => false)
      ap.send(:awesome, @hash).should == "{ 1\e[1;30m => \e[0m{ :sym\e[1;30m => \e[0m{ \"str\"\e[1;30m => \e[0m{ [ 1, 2, 3 ]\e[1;30m => \e[0m{ { :k => :v }\e[1;30m => \e[0m\e[1;33mHash < Object\e[0m } } } } }"
    end

  end

  #------------------------------------------------------------------------------
  describe "Nested Hash" do
    before(:each) do
      @hash = {}
      @hash[:a] = @hash
    end

    it "plain multiline" do
      ap = AwesomePrint.new(:plain => true)
      ap.send(:awesome, @hash).should == <<-EOS.strip
{
    :a => {...}
}
EOS
    end

    it "plain single line" do
      ap = AwesomePrint.new(:plain => true, :multiline => false)
      ap.send(:awesome, @hash).should == '{ :a => {...} }'
    end
  end

  #------------------------------------------------------------------------------
  describe "Class" do
    it "shoud show superclass (plain)" do
      ap = AwesomePrint.new(:plain => true)
      ap.send(:awesome, self.class).should == "#{self.class} < #{self.class.superclass}"
    end

    it "shoud show superclass (color)" do
      ap = AwesomePrint.new
      ap.send(:awesome_class, self.class).should == "#{self.class} < #{self.class.superclass}".yellow
    end
  end

  #------------------------------------------------------------------------------
  describe "File" do
    it "should display a file (plain)" do
      File.open(__FILE__, "r") do |f|
        @plain_ap.send(:awesome_file, f).should == "#{f.inspect}\n" << `ls -alF #{f.path}`.chop
      end
    end
  end

  #------------------------------------------------------------------------------
  describe "Dir" do
    it "should display a direcory (plain)" do
      Dir.open(File.dirname(__FILE__)) do |d|
        @plain_ap.send(:awesome_dir, d).should == "#{d.inspect}\n" << `ls -alF #{d.path}`.chop
      end
    end
  end

end
