autoload :CGI, 'cgi'
require 'shellwords'
require 'awesome_print/formatter_factory'
require 'awesome_print/type_discover'

module AwesomePrint
  class Formatter

    CORE = [ :array, :bigdecimal, :class, :dir, :file, :hash, :method, :rational, :set, :struct, :unboundmethod ]
    DEFAULT_LIMIT_SIZE = 7

    attr_reader :options, :inspector, :indentation, :type

    def initialize(inspector)
      @inspector   = inspector
      @options     = inspector.options
      @indentation = @options[:indent].abs
    end

    # Main entry point to format an object.
    #------------------------------------------------------------------------------
    def format(object, type = nil)
      @type = type
      core_class = cast(object, type)
      AwesomePrint::FormatterFactory.new(core_class, self, object).call
    end

    # Hook this when adding custom formatters. Check out lib/awesome_print/ext
    # directory for custom formatters that ship with awesome_print.
    #------------------------------------------------------------------------------
    def cast(object, type)
      AwesomePrint::TypeDiscover.new(object).call || CORE.grep(type)[0] || :self
    end

    # Pick the color and apply it to the given string as necessary.
    #------------------------------------------------------------------------------
    def colorize(str, type)
      str = CGI.escapeHTML(str) if @options[:html]
      if @options[:plain] || !@options[:color][type] || !@inspector.colorize?
        str
      #
      # Check if the string color method is defined by awesome_print and accepts
      # html parameter or it has been overriden by some gem such as colorize.
      #
      elsif str.method(@options[:color][type]).arity == -1 # Accepts html parameter.
        str.send(@options[:color][type], @options[:html])
      else
        str = %Q|<kbd style="color:#{@options[:color][type]}">#{str}</kbd>| if @options[:html]
        str.send(@options[:color][type])
      end
    end

    def indent
      ' ' * @indentation
    end

    def outdent
      ' ' * (@indentation - @options[:indent].abs)
    end

    def indented
      @indentation += @options[:indent].abs
      yield
    ensure
      @indentation -= @options[:indent].abs
    end

    def align(value, width)
      if @options[:multiline]
        if @options[:indent] > 0
          value.rjust(width)
        elsif @options[:indent] == 0
          indent + value.ljust(width)
        else
          indent[0, @indentation + @options[:indent]] + value.ljust(width)
        end
      else
        value
      end
    end

    def left_aligned
      current, @options[:indent] = @options[:indent], 0
      yield
    ensure
      @options[:indent] = current
    end
  end
end
