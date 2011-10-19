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

  0.upto(255) do |c|
    define_method "fg#{c}" do |*html|
      if html[0]
        hex = AwesomePrint::Colors.lookup_by_num(c)
        %Q|<pre style="color:#{hex}">#{self}</pre>|
      else
        "\033[38;5;#{c}m#{self}\033[0m"
      end
    end

    define_method "bg#{c}" do |*html|
      if html[0]
        hex = AwesomePrint::Colors.lookup_by_num(c)
        %Q|<pre style="background-color:#{hex}">#{self}</pre>|
      else
        "\033[48;5;#{c}m#{self}\033[0m"
      end
    end
  end

end
