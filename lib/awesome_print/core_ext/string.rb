# Copyright (c) 2010-2016 Michael Dvorkin and contributors
#
# Awesome Print is freely distributable under the terms of MIT license.
# See LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
class String
  #
  # ANSI color codes:
  #   \e => escape
  #   30 => color base
  #    1 => bright
  #    0 => normal
  #
  # For HTML coloring we use <kbd> tag instead of <span> to require monospace
  # font. Note that beloved <tt> has been removed from HTML5.
  #
  %w(gray red green yellow blue purple cyan white).zip(
  %w(black darkred darkgreen brown navy darkmagenta darkcyan slategray)).each_with_index do |(color, shade), i|

    term_bright_seq = "\e[1;#{30 + i}m%s\e[0m" # avoid calls to Integer#to_s

    define_method color do |html = false,*|
      if html
        %Q|<kbd style="color:#{color}">#{self}</kbd>|
      else
        term_bright_seq % self
      end
    end

    term_normal_seq = "\e[0;#{30 + i}m%s\e[0m" # avoid calls to Integer#to_s

    define_method "#{color}ish" do |html = false,*|
      if html
        %Q|<kbd style="color:#{shade}">#{self}</kbd>|
      else
        term_normal_seq % self
      end
    end
  end

  alias :black :grayish
  alias :pale  :whiteish

end
