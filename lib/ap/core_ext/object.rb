# Copyright (c) 2010 Michael Dvorkin
#
# Awesome Print is freely distributable under the terms of MIT license.
# See LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
class Object
  def awesome_inspect(options = {})
    ap = AwesomePrint.new(options)
    ap.send(:awesome, self).to_s
  end
end
