# Copyright (c) 2010-2011 Michael Dvorkin
#
# Awesome Print is freely distributable under the terms of MIT license.
# See LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
module AwesomePrintActionView

  # Use HTML colors and add default "debug_dump" class to the resulting HTML.
  def ap_debug(object, options = {})
    object.ai(options.merge(:html => true)).sub(/^<pre([\s>])/, '<pre class="debug_dump"\\1')
  end

  alias_method :ap, :ap_debug

end

ActionView::Base.send(:include, AwesomePrintActionView) if defined?(ActionView)
