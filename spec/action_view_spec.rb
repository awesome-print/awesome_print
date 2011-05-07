require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

begin
  require 'action_view'
  require 'ap/mixin/action_view'

  describe "AwesomePrint ActionView extension" do
    before(:each) do
      @view = ActionView::Base.new
    end
    
    it "uses HTML and adds 'debug_dump' class to plain <pre> tag" do
      markup = rand
      @view.ap(markup, :plain => true).should == %Q|<pre class="debug_dump">#{markup}</pre>|
    end

    it "uses HTML and adds 'debug_dump' class to colorized <pre> tag" do
      markup = ' &<hello>'
      @view.ap(markup).should == '<pre class="debug_dump" style="color:brown">&quot; &amp;&lt;hello&gt;&quot;</pre>'
    end
  end

rescue LoadError
  puts "Skipping ActionView specs..."
end
