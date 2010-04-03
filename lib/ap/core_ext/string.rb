# Copyright (c) 2010 Michael Dvorkin
#
# Awesome Print is freely distributable under the terms of MIT license.
# See LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
class String # :nodoc:

  [ :gray, :red, :green, :yellow, :blue, :purple, :cyan, :white ].each_with_index do |color, i|
    if STDOUT.tty? && ENV['TERM'] && ENV['TERM'] != 'dumb'
      define_method color          do "\033[1;#{30+i}m#{self}\033[0m" end
      define_method :"#{color}ish" do "\033[0;#{30+i}m#{self}\033[0m" end
    else
      define_method color do self end
      alias :"#{color}ish" color # <- This break Rdoc: Name or symbol expected (got #<RubyToken::TkDSTRING
    end
  end

  alias :black :grayish
  alias :pale  :whiteish

end
