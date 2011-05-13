# Copyright (c) 2010-2011 Michael Dvorkin
#
# Awesome Print is freely distributable under the terms of MIT license.
# See LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
class Object #:nodoc:
  # Remaining instance '_methods' are handled in core_ext/class.rb.
  %w(methods private_methods protected_methods public_methods singleton_methods).each do |name|
    original_method = instance_method(name)

    define_method name do |*args|
      methods = original_method.bind(self).call(*args)
      methods.instance_variable_set('@__awesome_methods__', self) # Evil?!
      methods.sort!
    end
  end
end
