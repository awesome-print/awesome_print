# Copyright (c) 2010-2016 Michael Dvorkin and contributors
#
# Awesome Print is freely distributable under the terms of MIT license.
# See LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
module AwesomePrint
  module ActionView
    # Use HTML colors and add default "debug_dump" class to the resulting HTML.
    def ap_debug(object, options = {})
      object.ai(
        {html: true}.merge(options)
      ).sub(
        /^<pre([\s>])/,
        '<pre class="debug_dump"\\1'
      )
    end

    alias ap ap_debug
  end
end

ActionView::Base.send(:include, AwesomePrint::ActionView)
