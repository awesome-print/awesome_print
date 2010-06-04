require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

require 'action_view'
require 'ap/mixin/action_view'

describe "AwesomePrint ActionView extensions" do
  before(:each) do
    @view = ActionView::Base.new
  end
    
  it "should wrap ap output with <pre> tag" do
    obj = 42
    @view.ap(obj, :plain => true).should == '<pre class="debug_dump">42</pre>'
  end

  it "should encode HTML entities" do
    obj = "  &<hello>"
    @view.ap(obj, :plain => true).should == '<pre class="debug_dump">&quot;  &amp;&lt;hello&gt;&quot;</pre>'
  end

  it "should convert primary ANSI colors to HTML" do
    obj = 42
    [ :gray, :red, :green, :yellow, :blue, :purple, :cyan, :white ].each do |color|
      @view.ap(obj, :color => { :fixnum => color }).should == %Q|<pre class="debug_dump"><font color="#{color}">42</font></pre>|
    end
  end

  it "should convert mixed ANSI colors to HTML" do
    obj = 42
    [ :grayish, :redish, :greenish, :yellowish, :blueish, :purpleish, :cyanish, :whiteish, :black, :pale ].zip(
    [ :black, :darkred, :darkgreen, :brown, :navy, :darkmagenta, :darkcyan, :slategray, :black, :slategray ]) do |ansi, html|
      @view.ap(obj, :color => { :fixnum => ansi }).should == %Q|<pre class="debug_dump"><font color="#{html}">42</font></pre>|
    end
  end
end
