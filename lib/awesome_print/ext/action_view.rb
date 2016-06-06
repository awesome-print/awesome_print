module AwesomePrint
  module ActionView

    # Use HTML colors and add default "debug_dump" class to the resulting HTML.
    def ap_debug(object, options = {})
      object.ai(options.merge(:html => true)).sub(/^<pre([\s>])/, '<pre class="debug_dump"\\1')
    end

    alias_method :ap, :ap_debug
  end
end

ActionView::Base.send(:include, AwesomePrint::ActionView)
