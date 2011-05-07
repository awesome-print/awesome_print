# Copyright (c) 2010-2011 Michael Dvorkin
#
# Awesome Print is freely distributable under the terms of MIT license.
# See LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
class String

  # ANSI color codes:
  # \033 => escape
  #   30 => color base
  #    1 => bright
  #    0 => normal

  %w(gray red green yellow blue purple cyan white).zip(
  %w(black darkred darkgreen brown navy darkmagenta darkcyan slategray)).each_with_index do |(color, shade), i|
    define_method color do |*html|
      html[0] ? %Q|<pre style="color:#{color}">#{self}</pre>| : "\033[1;#{30+i}m#{self}\033[0m"
    end

    define_method "#{color}ish" do |*html|
      html[0] ? %Q|<pre style="color:#{shade}">#{self}</pre>| : "\033[0;#{30+i}m#{self}\033[0m"
    end
  end

  alias :black :grayish
  alias :pale  :whiteish

end
