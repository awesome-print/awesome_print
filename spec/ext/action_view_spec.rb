require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

begin
  require 'action_view'
  require 'awesome_print/ext/action_view'

  describe "AwesomePrint ActionView extensions" do
    before do
      @view = ActionView::Base.new
    end
    
    it "uses HTML and adds 'debug_dump' class to plain <pre> tag" do
      markup = rand
      expect(@view.ap(markup, :plain => true)).to eq(%Q|<pre class="debug_dump">#{markup}</pre>|)
    end

    it "uses HTML and adds 'debug_dump' class to colorized <pre> tag" do
      markup = ' &<hello>'
      expect(@view.ap(markup)).to eq('<pre class="debug_dump"><kbd style="color:brown">&quot; &amp;&lt;hello&gt;&quot;</kbd></pre>')
    end
  end

rescue LoadError => error
  puts "Skipping ActionView specs: #{error}"
end
