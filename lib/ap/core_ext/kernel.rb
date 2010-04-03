# Copyright (c) 2010 Michael Dvorkin
#
# Awesome Print is freely distributable under the terms of MIT license.
# See LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
module Kernel

  def ap(object, options = {})
    ap = AwesomePrint.new(options)
    ap.puts object
  end

  module_function :ap
end
