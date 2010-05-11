# Copyright (c) 2010 Michael Dvorkin
#
# Awesome Print is freely distributable under the terms of MIT license.
# See LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
class String
  ANSI_ESCAPE = "\033"
  ANSI_COLOR_BASE = 30
  ANSI_BRIGHT = 1
  ANSI_NORMAL = 0

  [ :gray, :red, :green, :yellow, :blue, :purple, :cyan, :white ].each_with_index do |color, i|
    if STDOUT.tty? && ENV['TERM'] && ENV['TERM'] != 'dumb'
      define_method color          do "#{ANSI_ESCAPE}[#{ANSI_BRIGHT};#{ANSI_COLOR_BASE+i}m#{self}#{ANSI_ESCAPE}[#{ANSI_NORMAL}m" end
      define_method :"#{color}ish" do "#{ANSI_ESCAPE}[#{ANSI_NORMAL};#{ANSI_COLOR_BASE+i}m#{self}#{ANSI_ESCAPE}[#{ANSI_NORMAL}m" end
    else
      define_method color do self end
      alias_method :"#{color}ish", color 
    end
  end

  alias :black :grayish
  alias :pale  :whiteish

end
