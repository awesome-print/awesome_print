require_relative 'colorize'

module AwesomePrint
  class Formatter

    include Colorize

    attr_reader :inspector, :options

    # Acts as a class ivar
    @registered_formatters = {}

    # make it accessible
    def self.registered_formatters
      @registered_formatters
    end

    # register a new formatter..
    #------------------------------------------------------------------------------
    def self.register(formatter)
      @registered_formatters[formatter.formatted_object_type.to_sym] = formatter
    end

    def initialize(inspector)
      @inspector = inspector
      @options   = inspector.options
    end


    # Main entry point to format an object.
    # type is determined by Inspector#printable
    #------------------------------------------------------------------------------
    def format(object, type = nil)
      puts "[FORMAT] #{type.to_s.red} >>> #{object}"

      format_with = active_formatter(type)
      puts "[ACTIVE] using > #{format_with.to_s.blueish} < to format"

      if format_with && format_with.send(:formattable?, object)
        format_with.new(@inspector).format(object)
      else
        puts "[FALLBACK] well darn, we're just gonna have to fb"
        # in this case, formatter is missing or fails format test
        AwesomePrint::Formatters::FallbackFormatter.new(@inspector).format(object)
      end
    end

    def active_formatter(type)
      self.class.registered_formatters[type]
    end
  end
end

