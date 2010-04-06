# Copyright (c) 2010 Michael Dvorkin
#
# Awesome Print is freely distributable under the terms of MIT license.
# See LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
require File.dirname(__FILE__) + "/ap/core_ext/string"
require File.dirname(__FILE__) + "/ap/core_ext/kernel"
require File.dirname(__FILE__) + "/ap/core_ext/object"
require File.dirname(__FILE__) + "/ap/awesome_print"

require File.dirname(__FILE__) + "/ap/mixin/rails" if defined?(::Rails)
