require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "String extensions" do
  [ :gray, :red, :green, :yellow, :blue, :purple, :cyan, :white ].each_with_index do |color, i|
    it "should have #{color} color" do
      color.to_s.send(color).should == "\e[1;#{30+i}m#{color}\e[0m"
    end

    it "should have #{color}ish color" do
      color.to_s.send(:"#{color}ish").should == "\e[0;#{30+i}m#{color}\e[0m"
    end
  end

  it "should have black and pale colors" do
    "black".send(:black).should == "black".send(:grayish)
    "pale".send(:pale).should  == "pale".send(:whiteish)
    "pale".send(:pale).should == "\e[0;37mpale\e[0m"
    "whiteish".send(:whiteish).should == "\e[0;37mwhiteish\e[0m"
  end
end
