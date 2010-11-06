# Copyright (c) 2010 Michael Dvorkin
#
# Awesome Print is freely distributable under the terms of MIT license.
# See LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
class Array
  #
  # The following makes it possible to invoke awesome_print while performing
  # operations on method arrays, ex:
  # 
  #   ap [].methods - Object.methods
  #   ap ''.methods.grep(/!|\?/)
  # 
  # If you could think of a better way please let me know: twitter.com/mid :-)
  #
  [ :-, :& ].each do |operator|
    alias_method :"original_#{operator.object_id}", operator
    define_method operator do |*args|
      arr = self.send(:"original_#{operator.object_id}", *args)
      if self.instance_variable_defined?('@__awesome_methods__')
        arr.instance_variable_set('@__awesome_methods__', self.instance_variable_get('@__awesome_methods__'))
        arr.sort!
      end
      arr
    end
  end

  alias_method :original_grep, :grep
  define_method :grep do |*args, &blk|
    arr = original_grep(*args, &blk)
    if self.instance_variable_defined?('@__awesome_methods__')
      arr.instance_variable_set('@__awesome_methods__', self.instance_variable_get('@__awesome_methods__'))
      arr.reject! { |item| !(item.is_a?(Symbol) || item.is_a?(String)) } # grep block might return crap.
    end
    arr
  end
end
