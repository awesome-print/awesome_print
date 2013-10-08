# Copyright (c) 2010-2013 Michael Dvorkin
#
# Awesome Print is freely distributable under the terms of MIT license.
# See LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
module AwesomePrint
  class Plugin
    def self.add(mod)
      formatter = AwesomePrint::Formatter
      formatter.send(:include, mod)

      hook = mod.name.gsub(/^.*::/, "").gsub!(/(.)([A-Z])/, '\1_\2').downcase
      formatter.send(:alias_method, :"cast_without_#{hook}", :cast)
      formatter.send(:alias_method, :cast, :"cast_with_#{hook}")
    end
  end
end
