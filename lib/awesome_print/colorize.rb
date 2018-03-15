autoload :CGI, 'cgi'

module AwesomePrint
  module Colorize

    # Pick the color and apply it to the given string as necessary.
    #------------------------------------------------------------------------------
    def colorize(str, type)
      # cache (this method can be called many times for just one call to #ai)
      # NOTE: MUST NOT cache options[:plain]. (see HashFormatter)
      @options_color = options[:color] unless defined? @options_color
      @options_html  = options[:html]  unless defined? @options_html
      color          = @options_color[type]

      str = CGI.escapeHTML(str) if @options_html # WTF is this doing here

      return str if options[:plain] || !color || !inspector.colorize?

      # Common case: HTML is not wanted.
      return str.send(color) unless @options_html

      ###
      # Special case: HTML is wanted.
      #

      #
      # Check if the string color method is defined by awesome_print and accepts
      # html parameter or it has been overriden by some gem such as colorize.
      #
      if str.method(color).arity == -1 # Accepts html parameter.
        # TODO: Redundant. Just always do HTML colorizing here, remove html param from color methods on String.
        str.send(color, @options_html)
      else
        %Q|<kbd style="color:#{color}">#{str}</kbd>|.send(color) # WTF? ANSI-colorize the HTML?
      end
    end
  end
end
