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

  [ :gray, :red, :green, :yellow, :blue, :purple, :cyan, :white ].each_with_index do |color, i|
    define_method color do
      if AwesomePrint.allow_colors?
        "\033[1;#{30+i}m#{self}\033[0m"
      else
        self
      end
    end

    define_method :"#{color}ish" do
      if AwesomePrint.allow_colors?
        "\033[0;#{30+i}m#{self}\033[0m"
      else
        self
      end
    end
  end

  alias :black :grayish
  alias :pale  :whiteish

end
