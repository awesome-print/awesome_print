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
      puts "[FORMAT] #{type.to_s.red} >>> #{object}" if AwesomePrint.debug

      format_with = active_formatter(type)
      puts "[ACTIVE] using > #{format_with.to_s.blueish} < to format" if AwesomePrint.debug

      # if we have an active formatter, and it's good to go, lets return that

      return format_with.new(@inspector).format(object) if format_with&.formattable?(object)

      # if that's not working, lets try discover the format via formattable?
      self.class.registered_formatters.each do |fmt|
        puts "[FORMATTABLE] trying to use #{fmt} - #{fmt.last.core?}" if AwesomePrint.debug
        next if fmt.last.core? # if it's a core level formatter, move on

        return fmt.last.new(@inspector).format(object) if fmt.last.formattable?(object)
      end

      # we've run out of options. lets try and coerce into something we can work
      # with
      puts "[FALLBACK] well darn, we're just gonna have to fb" if AwesomePrint.debug
      AwesomePrint::Formatters::FallbackFormatter.new(@inspector).format(object)
    end

    def active_formatter(type)
      self.class.registered_formatters[type]
    end
  end
end

