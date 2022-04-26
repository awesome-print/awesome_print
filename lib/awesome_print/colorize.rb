autoload :CGI, 'cgi'

module AwesomePrint
  module Colorize
    class << self
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
        define_method color do |*args|
          args[1] ? %Q|<kbd style="color:#{color}">#{args[0]}</kbd>| : "\e[1;#{30 + i}m#{args[0]}\e[0m"
        end

        define_method "#{color}ish" do |*args|
          args[1] ? %Q|<kbd style="color:#{shade}">#{args[0]}</kbd>| : "\e[0;#{30 + i}m#{args[0]}\e[0m"
        end
      end

      alias :black :grayish
      alias :pale  :whiteish
    end

    # Pick the color and apply it to the given string as necessary.
    #------------------------------------------------------------------------------
    def colorize(str, type)
      str = CGI.escapeHTML(str) if options[:html]
      if options[:plain] || !options[:color][type] || !inspector.colorize?
        str
      #
      # Check if the string color method is defined by awesome_print and accepts
      # html parameter or it has been overriden by some gem such as colorize.
      #
      elsif AwesomePrint::Colorize.method(options[:color][type]).arity == -1 # Accepts html parameter.
        AwesomePrint::Colorize.public_send(options[:color][type], str, options[:html])
      else
        str = %Q|<kbd style="color:#{options[:color][type]}">#{str}</kbd>| if options[:html]
        AwesomePrint::Colorize.public_send(options[:color][type], str)
      end
    end
  end
end
