module AwesomePrintActionView

  def ap_debug(object, options = {})
    formatted = object.ai(options)

    if options[:plain]
      %Q|<pre class="debug_dump">#{h(formatted).gsub("  ", "&nbsp; ")}</pre>|
    else
      hash = {} # Build ANSI => HTML color map.
      [ :gray, :red, :green, :yellow, :blue, :purple, :cyan, :white ].each_with_index do |color, i|
        hash["\033[1;#{30+i}m"] = color
      end
      [ :black, :darkred, :darkgreen, :sienna, :navy, :darkmagenta, :darkcyan, :slategray ].each_with_index do |color, i|
        hash["\033[0;#{30+i}m"] = color
      end

      formatted = h(formatted).gsub("  ", "&nbsp; ")
      hash.each do |key, value|
        formatted.gsub!(key, %Q|<font color="#{value}">|)
      end
      formatted.gsub!("\033[0m", "</font>")
      %Q|<pre class="debug_dump">#{formatted}</pre>|
    end

  end
  alias_method :ap, :ap_debug

end

ActionView::Base.send(:include, AwesomePrintActionView) if defined?(::ActionView)
