require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Colors" do

  describe " -- RGB Helper Methods" do
    
    it "should return 255 from an invalid array" do
      result = AwesomePrint::Colors.rgb 300, 300, 300
      result.should == "255"
    end

    it "should return 17 from [0,0,95]" do 
      result = AwesomePrint::Colors.rgb 0, 0, 95
      result.should == "17"
    end

  end

  describe " -- Hex Helper Methods" do 

    it "should return the string from an invalid hex" do
      result = AwesomePrint::Colors.hex "testing"
      result.should == "testing"
    end

    it "should return a proper colour with 00005f" do
      result = AwesomePrint::Colors.hex "00005f"
      result.should == "fg17"
    end

    it "should return a proper colour with 00005F" do
      result = AwesomePrint::Colors.hex "00005F"
      result.should == "fg17"
    end

    it "should return a proper colour with #00005F" do
      result = AwesomePrint::Colors.hex "#00005F"
      result.should == "fg17"
    end

  end

  describe " -- Lookup by number" do
    
    it "should return #EEEEEE from an invalid number" do
      result = AwesomePrint::Colors.lookup_by_num(0)
      result.should == "#EEEEEE"
    end

    it "should return valid hex from valid numbers" do
      result = AwesomePrint::Colors.lookup_by_num(16)
      result.should == "#000000"

      result = AwesomePrint::Colors.lookup_by_num(255)
      result.should == "#EEEEEE"
    end

  end

  describe " -- Inspect string with colors" do

    before(:all) do
      @s = "Test"
    end

    it "should use a symbol as a standard color" do
      result = @s.ai(:color => { :string => :red })
      result.should == "\e[1;31m\"Test\"\e[0m"
    end

    it "should use an array as an RGB value" do
      result = @s.ai(:color => { :string => [0, 0, 95] })
      result.should == "\e[38;5;17m\"Test\"\e[0m"
    end

    it "should use a number as a raw extended color" do
      result = @s.ai(:color => { :string => 17 })
      result.should == "\e[38;5;17m\"Test\"\e[0m"
    end

    it "should use a string as a hex code" do
      result = @s.ai(:color => { :string => "#00005F" })
      result.should == "\e[38;5;17m\"Test\"\e[0m"
    end

    it "should use a string as a standard color" do
      result = @s.ai(:color => { :string => "red" })
      result.should == "\e[1;31m\"Test\"\e[0m"
    end

  end

end
