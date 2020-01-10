# Copyright (c) 2010-2016 Michael Dvorkin and contributors
#
# Awesome Print is freely distributable under the terms of MIT license.
# See LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
require_relative 'indentator'

module AwesomePrint
  class Inspector
    attr_accessor :options, :indentator

    AP = :__awesome_print__

    def initialize(options = {})
      @options = {
        indent:        4,      # Number of spaces for indenting.
        index:         true,   # Display array indices.
        html:          false,  # Use ANSI color codes rather than HTML.
        multiline:     true,   # Display in multiple lines.
        plain:         false,  # Use colors.
        raw:           false,  # Do not recursively format instance variables.
        sort_keys:     false,  # Do not sort hash keys.
        sort_vars:     true,   # Sort instance variables.
        limit:         false,  # Limit arrays & hashes. Accepts bool or int.
        ruby19_syntax: false,  # Use Ruby 1.9 hash syntax in output.
        class_name:    :class, # Method used to get Instance class name.
        object_id:     true,   # Show object_id.
        color: {
          args:       :pale,
          array:      :white,
          bigdecimal: :blue,
          class:      :yellow,
          date:       :greenish,
          falseclass: :red,
          fixnum:     :blue,
          integer:    :blue,
          float:      :blue,
          hash:       :pale,
          keyword:    :cyan,
          method:     :purpleish,
          nilclass:   :red,
          rational:   :blue,
          string:     :yellowish,
          struct:     :pale,
          symbol:     :cyanish,
          time:       :greenish,
          trueclass:  :green,
          variable:   :cyanish
        }
      }

      # Merge custom defaults and let explicit options parameter override them.
      merge_custom_defaults!
      merge_options!(options)

      @formatter = AwesomePrint::Formatter.new(self)
      @indentator = AwesomePrint::Indentator.new(@options[:indent].abs)
      Thread.current[AP] ||= []
    end

    def current_indentation
      indentator.indentation
    end

    def increase_indentation(&block)
      indentator.indent(&block)
    end

    # Dispatcher that detects data nesting and invokes object-aware formatter.
    #---------------------------------------------------------------------------
    def awesome(object)
      if Thread.current[AP].include?(object.object_id)
        nested(object)
      else
        begin
          Thread.current[AP] << object.object_id
          unnested(object)
        ensure
          Thread.current[AP].pop
        end
      end
    end

    # Return true if we are to colorize the output.
    #---------------------------------------------------------------------------
    def colorize?
      AwesomePrint.force_colors ||= false
      AwesomePrint.force_colors || (
        STDOUT.tty? && (
          (
            ENV['TERM'] &&
            ENV['TERM'] != 'dumb'
          ) ||
          ENV['ANSICON']
        )
      )
    end

    private

    # Format nested data, for example:
    #   arr = [1, 2]; arr << arr
    #   => [1,2, [...]]
    #   hash = { :a => 1 }; hash[:b] = hash
    #   => { :a => 1, :b => {...} }
    #---------------------------------------------------------------------------
    def nested(object)
      case printable(object)
      when :array  then @formatter.colorize('[...]', :array)
      when :hash   then @formatter.colorize('{...}', :hash)
      when :struct then @formatter.colorize('{...}', :struct)
      else @formatter.colorize("...#{object.class}...", :class)
      end
    end

    #---------------------------------------------------------------------------
    def unnested(object)
      @formatter.format(object, printable(object))
    end

    # Turn class name into symbol, ex: Hello::World => :hello_world. Classes
    # that inherit from Array, Hash, File, Dir, and Struct are treated as the
    # base class.
    #---------------------------------------------------------------------------
    def printable(object)
      case object
      when Array  then :array
      when Hash   then :hash
      when File   then :file
      when Dir    then :dir
      when Struct then :struct
      else object.class.to_s.gsub(/:+/, '_').downcase.to_sym
      end
    end

    # Update @options by first merging the :color hash and then the remaining
    # keys.
    #---------------------------------------------------------------------------
    def merge_options!(options = {})
      @options[:color].merge!(options.delete(:color) || {})
      @options.merge!(options)
    end

    # This method needs to be mocked during testing so that it always loads
    # predictable values
    #---------------------------------------------------------------------------
    def load_dotfile
      dotfile = File.join(ENV['HOME'], '.aprc')
      load dotfile if dotfile_readable?(dotfile)
    end

    def dotfile_readable? dotfile
      if @@dotfile_readable.nil? || @@dotfile != dotfile
        @@dotfile_readable = File.readable?(@@dotfile = dotfile)
      end
      @@dotfile_readable
    end
    @@dotfile_readable = @@dotfile = nil

    # Load ~/.aprc file with custom defaults that override default options.
    #---------------------------------------------------------------------------
    def merge_custom_defaults!
      load_dotfile
      merge_options!(AwesomePrint.defaults) if AwesomePrint.defaults.is_a?(Hash)
    rescue => e
      $stderr.puts "Could not load '.aprc' from ENV['HOME']: #{e}"
    end
  end
end
