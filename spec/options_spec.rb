require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "AwesomePrint" do
  describe "Options" do
    before do
      stub_dotfile!
      @ap = AwesomePrint::Inspector.new
    end

    it "should merge options" do
      @ap.send(:merge_options!, { :color => { :array => :black }, :indent => 0 })
      options = @ap.instance_variable_get("@options")
      options[:color][:array].should == :black
      options[:indent].should == 0
    end

    it "empty list" do
      @ap.send(:hashify, []).should == {}
    end

    it "hash only" do
      @ap.send(:hashify, [ { html: true, plain: true } ]).should == { html: true, plain: true }
    end

    it "symbol without [no] prefix" do
      @ap.send(:hashify, [ :index ]).should == { index: true }
    end

    it "multiple symbols without [no] prefix" do
      @ap.send(:hashify, [ :index, :plain ]).should == { index: true, plain: true }
    end

    it "symbol with [no] prefix" do
      @ap.send(:hashify, [ :noindex ]).should == { index: false }
    end

    it "multiple symbols with [no] prefix" do
      @ap.send(:hashify, [ :noindex, :noplain ]).should == { index: false, plain: false }
    end

    it "multiple symbols with and without [no] prefix" do
      @ap.send(:hashify, [ :noindex, :plain ]).should == { index: false, plain: true }
    end

    it "mixing symbols and hashes #1" do
      @ap.send(:hashify, [ :noindex, { plain: false } ]).should == { index: false, plain: false }
    end

    it "mixing symbols and hashes #2" do
      @ap.send(:hashify, [ { plain: true }, :noindex, :noplain ]).should == { index: false, plain: false }
    end

    it "mixing symbols and hashes #3" do
      @ap.send(:hashify, [ { plain: false }, :noindex, :plain ]).should == { index: false, plain: true }
    end

    it "mixing symbols and hashes #4" do
      @ap.send(:hashify, [ { plain: false }, :noindex, { multiline: true } ]).should == { plain: false, index: false, multiline: true }
    end

    it "mixing symbols and hashes #5" do
      @ap.send(:hashify, [ { color: { array: :red } }, :noindex, :plain ]).should == { color: { array: :red }, index: false, plain: true }
    end
  end
end
