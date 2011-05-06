require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require "bigdecimal"
require "rational"

describe "AwesomePrint" do
  before(:each) do
    stub_dotfile!
  end

  #------------------------------------------------------------------------------
  describe "OpenStruct" do
    before(:each) do
      @struct = OpenStruct.new
      @struct.name = "Herman Munster"
      @struct.address = "1313 Mockingbird Lane"
    end
    
    it "empty struct" do
      OpenStruct.new.ai.should ==  "{}"
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
end
