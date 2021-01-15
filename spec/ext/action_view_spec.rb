require 'spec_helper'

RSpec.describe 'AwesomePrint ActionView extensions', skip: -> { !ExtVerifier.has_rails? }.call do
  before do
    @view = if rails_6_1?
              ActionView::Base.new(ActionView::LookupContext.new([]), {}, {})
            else
              ActionView::Base.new
            end
  end

  it "uses HTML and adds 'debug_dump' class to plain <pre> tag" do
    markup = rand
    expect(@view.ap(markup, plain: true)).to eq(%Q|<pre class="debug_dump">#{markup}</pre>|)
  end

  it "uses HTML and adds 'debug_dump' class to colorized <pre> tag" do
    markup = ' &<hello>'
    expect(@view.ap(markup)).to eq('<pre class="debug_dump"><kbd style="color:brown">&quot; &amp;&lt;hello&gt;&quot;</kbd></pre>')
  end
end
