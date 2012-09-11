# Copyright (c) 2010-2012 Michael Dvorkin
#
# Awesome Print is freely distributable under the terms of MIT license.
# See LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
module Kernel

  def ai(options = {})
    ap = AwesomePrint::Inspector.new(options)
    ap.awesome self
  end
  alias :awesome_inspect :ai

  def ap(object, options = {})
    puts object.ai(options)
    object unless AwesomePrint.console?
  end
  alias :awesome_print :ap

  module_function :ap
end
