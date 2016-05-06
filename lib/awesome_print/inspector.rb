module AwesomePrint
  class Inspector
    attr_accessor :options

    AP = :__awesome_print__

    def initialize(options = {})
      @options = {
        :indent               => 4,      # Indent using 4 spaces.
        :index                => true,   # Display array indices.
        :html                 => false,  # Use ANSI color codes rather than HTML.
        :multiline            => true,   # Display in multiple lines.
        :plain                => false,  # Use colors.
        :raw                  => false,  # Do not recursively format object instance variables.
        :sort_keys            => false,  # Do not sort hash keys.
        :limit                => false,  # Limit large output for arrays and hashes. Set to a boolean or integer.
        :colonize_symbol_keys => false,  # Use the foo: 'bar' syntax, when the key is a symbol
        :color => {
          :args       => :pale,
          :array      => :white,
          :bigdecimal => :blue,
          :class      => :yellow,
          :date       => :greenish,
          :falseclass => :red,
          :fixnum     => :blue,
          :float      => :blue,
          :hash       => :pale,
          :keyword    => :cyan,
          :method     => :purpleish,
          :nilclass   => :red,
          :rational   => :blue,
          :string     => :yellowish,
          :struct     => :pale,
          :symbol     => :cyanish,
          :time       => :greenish,
          :trueclass  => :green,
          :variable   => :cyanish
        }
      }

      # Merge custom defaults and let explicit options parameter override them.
      merge_custom_defaults!
      merge_options!(options)

      @formatter = AwesomePrint::Formatter.new(self)
      Thread.current[AP] ||= []
    end

    # Dispatcher that detects data nesting and invokes object-aware formatter.
    #------------------------------------------------------------------------------
    def awesome(object)
      if Thread.current[AP].include?(object.object_id)
        @formatter.nested(object)
      else
        begin
          Thread.current[AP] << object.object_id
          @formatter.unnested(object)
        ensure
          Thread.current[AP].pop
        end
      end
    end

    # Return true if we are to colorize the output.
    #------------------------------------------------------------------------------
    def colorize?
      AwesomePrint.force_colors ||= false
      AwesomePrint.force_colors || (STDOUT.tty? && ((ENV['TERM'] && ENV['TERM'] != 'dumb') || ENV['ANSICON']))
    end

    private

    # Update @options by first merging the :color hash and then the remaining keys.
    #------------------------------------------------------------------------------
    def merge_options!(options = {})
      @options[:color].merge!(options.delete(:color) || {})
      @options.merge!(options)
    end

    # Load ~/.aprc file with custom defaults that override default options.
    #------------------------------------------------------------------------------
    def merge_custom_defaults!
      dotfile = File.join(ENV["HOME"], ".aprc")
      load dotfile if File.readable?(dotfile)
      merge_options!(AwesomePrint.defaults) if AwesomePrint.defaults.is_a?(Hash)
    rescue => e
      $stderr.puts "Could not load #{dotfile}: #{e}"
    end
  end
end
