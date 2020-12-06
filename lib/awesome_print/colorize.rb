autoload :CGI, 'cgi'

require 'paint'

module AwesomePrint
  module Colorize

    UNCOLORIZE_REGEXP = /\e\[([;\d]+)?m/

    # ### References
    # - https://stackoverflow.com/questions/16032726/removing-color-decorations-from-strings-before-writing-them-to-logfiles
    def uncolorize(str)
      str.gsub(UNCOLORIZE_REGEXP, '')
    end

    # Pick the color and apply it to the given string as necessary.
    #------------------------------------------------------------------------------
    def colorize(str, types)
      types = [types] if !types.is_a?(::Array)

      types = types
        .map { |type| options[:color][type] || options[:color][:unknown] }
        .flatten
        .compact

      if options[:plain] || !inspector.colorize?
        str
      elsif options[:html]
        styles = types.map do |el|
          case type.to_s
          when 'italic'
            "font-style: italic"
          when 'bold'
            "font-weight: bold"
          else
            "color: #{ type }"
          end
        end

        "<kbd style='#{ styles.compact.join(';') }'>#{ CGI.escapeHTML(str) }</kbd>"
      else
        # ### Reference
        # - https://github.com/janlelis/paint
        list = [str] + types
        ::Paint[*list]
       end
     end

  end
end
