require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Single method" do
  it "plain: should handle a method with no arguments" do
    method = ''.method(:upcase)
    method.ai(:plain => true).should == 'String#upcase()'
  end

  it "color: should handle a method with no arguments" do
    method = ''.method(:upcase)
    method.ai.should == "\e[1;33mString\e[0m#\e[1;35mupcase\e[0m(\e[0;37m\e[0m)"
  end

  it "plain: should handle a method with one argument" do
    method = ''.method(:match)
    method.ai(:plain => true).should == 'String#match(arg1)'
  end

  it "color: should handle a method with one argument" do
    method = ''.method(:match)
    method.ai.should == "\e[1;33mString\e[0m#\e[1;35mmatch\e[0m(\e[0;37marg1\e[0m)"
  end

  it "plain: should handle a method with two arguments" do
    method = ''.method(:tr)
    method.ai(:plain => true).should == 'String#tr(arg1, arg2)'
  end

  it "color: should handle a method with two arguments" do
    method = ''.method(:tr)
    method.ai.should == "\e[1;33mString\e[0m#\e[1;35mtr\e[0m(\e[0;37marg1, arg2\e[0m)"
  end

  it "plain: should handle a method with multiple arguments" do
    method = ''.method(:split)
    method.ai(:plain => true).should == 'String#split(arg1, ...)'
  end

  it "color: should handle a method with multiple arguments" do
    method = ''.method(:split)
    method.ai.should == "\e[1;33mString\e[0m#\e[1;35msplit\e[0m(\e[0;37marg1, ...\e[0m)"
  end

  it "plain: should handle a method defined in mixin" do
    method = ''.method(:grep)
    method.ai(:plain => true).should == 'String (Enumerable)#grep(arg1)'
  end

  it "color: should handle a method defined in mixin" do
    method = ''.method(:grep)
    method.ai.should == "\e[1;33mString (Enumerable)\e[0m#\e[1;35mgrep\e[0m(\e[0;37marg1\e[0m)"
  end
end
