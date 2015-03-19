autoload :CGI, 'cgi'
require 'shellwords'
require 'awesome_print/formatter_factory'
require 'awesome_print/type_discover'

module AwesomePrint
  class Formatter

    attr_reader :options, :inspector, :indentation, :type, :object

    def initialize(inspector)
      @inspector   = inspector
      @options     = inspector.options
      @indentation = @options[:indent].abs
    end

    # Main entry point to format an object.
    #------------------------------------------------------------------------------
    def format(object)
      @type = printable(object)
      @object = object
      AwesomePrint::FormatterFactory.from(self, object)
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

    # Format nested data, for example:
    #   arr = [1, 2]; arr << arr
    #   => [1,2, [...]]
    #   hash = { :a => 1 }; hash[:b] = hash
    #   => { :a => 1, :b => {...} }
    #------------------------------------------------------------------------------
    def nested(object)
      case printable(object)
        when :array  then colorize("[...]", :array)
        when :hash   then colorize("{...}", :hash)
        when :struct then colorize("{...}", :struct)
        else colorize("...#{object.class}...", :class)
      end
    end

    #------------------------------------------------------------------------------
    def unnested(object)
      format(object)
    end

    # Turn class name into symbol, ex: Hello::World => :hello_world. Classes that
    # inherit from Array, Hash, File, Dir, and Struct are treated as the base class.
    #------------------------------------------------------------------------------
    def printable(object)
      case object
      when Array  then :array
      when Hash   then :hash
      when File   then :file
      when Dir    then :dir
      when Struct then :struct
      else object.class.to_s.gsub(/:+/, "_").downcase.to_sym
      end
    end
  end
end
