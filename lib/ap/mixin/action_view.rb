# Copyright (c) 2010-2011 Michael Dvorkin
#
# Awesome Print is freely distributable under the terms of MIT license.
# See LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
module AwesomePrintActionView

  def self.included(base)
    unless base.const_defined?(:AP_ANSI_TO_HTML)
      hash = {} # Build ANSI => HTML color map.
      [ :gray, :red, :green, :yellow, :blue, :purple, :cyan, :white ].each_with_index do |color, i|
        hash["\033[1;#{30+i}m"] = color
      end
      [ :black, :darkred, :darkgreen, :brown, :navy, :darkmagenta, :darkcyan, :slategray ].each_with_index do |color, i|
        hash["\033[0;#{30+i}m"] = color
      end
      base.const_set(:AP_ANSI_TO_HTML, hash.freeze)
    end
  end

  def ap_debug(object, options = {})
    formatted = h(object.ai(options))

    unless options[:plain]
      self.class::AP_ANSI_TO_HTML.each do |key, value|
        formatted.gsub!(key, %Q|<font color="#{value}">|)
      end
      formatted.gsub!("\033[0m", "</font>")
    end

    content_tag(:pre, formatted, :class => "debug_dump")
  end

  alias_method :ap, :ap_debug

end

ActionView::Base.send(:include, AwesomePrintActionView) if defined?(ActionView)
