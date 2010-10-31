require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Single method" do
  it "plain: should handle a method with no arguments" do
    method = ''.method(:upcase)
    method.ai(:plain => true).should == 'String#upcase()'
  end

  it "color: should handle a method with no arguments" do
    method = ''.method(:upcase)
    method.ai.should == "\e[1;33mString\e[0m#\e[1;35mupcase\e[0m\e[0;37m()\e[0m"
  end

  it "plain: should handle a method with one argument" do
    method = ''.method(:match)
    method.ai(:plain => true).should == 'String#match(arg1)'
  end

  it "color: should handle a method with one argument" do
    method = ''.method(:match)
    method.ai.should == "\e[1;33mString\e[0m#\e[1;35mmatch\e[0m\e[0;37m(arg1)\e[0m"
  end

  it "plain: should handle a method with two arguments" do
    method = ''.method(:tr)
    method.ai(:plain => true).should == 'String#tr(arg1, arg2)'
  end

  it "color: should handle a method with two arguments" do
    method = ''.method(:tr)
    method.ai.should == "\e[1;33mString\e[0m#\e[1;35mtr\e[0m\e[0;37m(arg1, arg2)\e[0m"
  end

  it "plain: should handle a method with multiple arguments" do
    method = ''.method(:split)
    method.ai(:plain => true).should == 'String#split(arg1, ...)'
  end

  it "color: should handle a method with multiple arguments" do
    method = ''.method(:split)
    method.ai.should == "\e[1;33mString\e[0m#\e[1;35msplit\e[0m\e[0;37m(arg1, ...)\e[0m"
  end

  it "plain: should handle a method defined in mixin" do
    method = ''.method(:grep)
    method.ai(:plain => true).should == 'String (Enumerable)#grep(arg1)'
  end

  it "color: should handle a method defined in mixin" do
    method = ''.method(:grep)
    method.ai.should == "\e[1;33mString (Enumerable)\e[0m#\e[1;35mgrep\e[0m\e[0;37m(arg1)\e[0m"
  end

  it "plain: should handle an unbound method" do
    class Hello
      def world; end
    end
    method = Hello.instance_method(:world)
    method.ai(:plain => true).should == 'Hello (unbound)#world()'
    Object.instance_eval{ remove_const :Hello }
  end

  it "color: should handle an unbound method" do
    class Hello
      def world(a,b); end
    end
    method = Hello.instance_method(:world)
    method.ai.should == "\e[1;33mHello (unbound)\e[0m#\e[1;35mworld\e[0m\e[0;37m(arg1, arg2)\e[0m"
  end
end

describe "object.methods" do
  it "index: should handle object.methods" do
    out = nil.methods.ai(:plain => true).grep(/is_a\?/).first
    out.should =~ /^\s+\[\s*\d+\]\s+is_a\?\(arg1\)\s+NilClass \(Kernel\)\n$/
  end

  it "no index: should handle object.methods" do
    out = nil.methods.ai(:plain => true, :index => false).grep(/is_a\?/).first
    out.should =~ /^\s+is_a\?\(arg1\)\s+NilClass \(Kernel\)\n$/
  end
end

describe "object.public_methods" do
  it "index: should handle object.public_methods" do
    out = nil.public_methods.ai(:plain => true).grep(/is_a\?/).first
    out.should =~ /^\s+\[\s*\d+\]\s+is_a\?\(arg1\)\s+NilClass \(Kernel\)\n$/
  end

  it "no index: should handle object.public_methods" do
    out = nil.public_methods.ai(:plain => true, :index => false).grep(/is_a\?/).first
    out.should =~ /^\s+is_a\?\(arg1\)\s+NilClass \(Kernel\)\n$/
  end
end

describe "object.private_methods" do
  it "index: should handle object.private_methods" do
    out = nil.private_methods.ai(:plain => true).grep(/sleep/).first
    out.should =~ /^\s+\[\s*\d+\]\s+sleep\(arg1,\s\.{3}\)\s+NilClass \(Kernel\)\n$/
  end

  it "no index: should handle object.private_methods" do
    out = nil.private_methods.ai(:plain => true, :index => false).grep(/sleep/).first
    out.should =~ /^\s+sleep\(arg1,\s\.{3}\)\s+NilClass \(Kernel\)\n$/
  end
end

describe "object.protected_methods" do
  it "index: should handle object.protected_methods" do
    class Hello
      protected
      def one; end
      def two; end
    end
    Hello.new.protected_methods.ai(:plain => true).should == "[\n    [0] one() Hello\n    [1] two() Hello\n]"
    Object.instance_eval{ remove_const :Hello }
  end

  it "index: should handle object.protected_methods" do
    class Hello
      protected
      def world(a,b); end
    end
    Hello.new.protected_methods.ai(:plain => true, :index => false).should == "[\n     world(arg1, arg2) Hello\n]"
    Object.instance_eval{ remove_const :Hello }
  end
end

