# Copyright (c) 2010-2011 Michael Dvorkin
#
# Awesome Print is freely distributable under the terms of MIT license.
# See LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
#
# The following makes it possible to invoke awesome_print while performing
# operations on method arrays, ex:
#
#   ap [].methods - Object.methods
#   ap ''.methods.grep(/!|\?/)
#
# If you could think of a better way please let me know :-)
#
class Array #:nodoc:
  [ :-, :& ].each do |operator|
    alias :"original_#{operator.object_id}" :"#{operator}"
    define_method operator do |*args|
      arr = self.__send__(:"original_#{operator.object_id}", *args)
      if self.instance_variable_defined?('@__awesome_methods__')
        arr.instance_variable_set('@__awesome_methods__', self.instance_variable_get('@__awesome_methods__'))
        arr.sort!
      end
      arr
    end
  end
  #
  # Intercepting Array#grep needs a special treatment since grep accepts
  # an optional block.
  #
  alias :original_grep :grep
  def grep(pattern, &blk)
    #
    # The following looks rather insane and I've sent numerous hours trying
    # to figure it out. The problem is that if grep gets called with the
    # block, for example:
    #
    #    [].methods.grep(/(.+?)_by/) { $1.to_sym }
    #
    # ...then simple:
    #
    #    original_grep(pattern, &blk)
    #
    # doesn't set $1 within the grep block which causes nil.to_sym failure.
    # The workaround below has been tested with Ruby 1.8.7/Rails 2.3.8 and
    # Ruby 1.9.2/Rails 3.0.0. For more info see the following thread dating
    # back to 2003 when Ruby 1.8.0 was as fresh off the grill as Ruby 1.9.2
    # is in 2010 :-)
    #
    # http://www.justskins.com/forums/bug-when-rerouting-string-52852.html
    #
    # BTW, if you figure out a better way of intercepting Array#grep please
    # let me know: twitter.com/mid -- or just say hi so I know you've read
    # the comment :-)
    #
    arr = unless blk
      original_grep(pattern)
    else
      original_grep(pattern) { |match| eval("%Q/#{match}/ =~ #{pattern.inspect}", blk.binding); yield match }
    end
    if self.instance_variable_defined?('@__awesome_methods__')
      arr.instance_variable_set('@__awesome_methods__', self.instance_variable_get('@__awesome_methods__'))
      arr.reject! { |item| !(item.is_a?(Symbol) || item.is_a?(String)) } # grep block might return crap.
    end
    arr
  end
end
