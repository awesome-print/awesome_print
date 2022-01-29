# Copyright (c) 2010-2016 Michael Dvorkin and contributors
#
# Awesome Print is freely distributable under the terms of MIT license.
# See LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
require_relative 'indentator'

module AwesomePrint
  class Inspector
    attr_accessor :options, :indentator

    APN  = :__awesome_print_nesting__
    APGN = :__awesome_print_global_nesting__

    MONOKAI_PRO = {
      red:    '#ff6188',
      orange: '#fc9867',
      yellow: '#ffd866',
      green:  '#a9dc76',
      blue:   '#78dce8',
      purple: '#ab9df2',
      base0:  '#19181a',
      base1:  '#221f22',
      base2:  '#2d2a2e',
      base3:  '#403e41',
      base4:  '#5b595c',
      base5:  '#727072',
      base6:  '#939293',
      #base7:  '#c1c0c0',
      base7:  '#cecec1',
      base8:  '#fcfcfa',
    }

    def initialize(options = {})
      @options = {
        indent:            4,      # Number of spaces for indenting.
        index:             true,   # Display array indices.
        html:              false,  # Use ANSI color codes rather than HTML.
        multiline:         true,   # Display in multiple lines.
        plain:             false,  # Use colors.
        raw:               false,  # Do not recursively format instance variables.
        sort_keys:         false,  # Do not sort hash keys.
        sort_vars:         true,   # Sort instance variables.
        limit:             false,  # Limit arrays & hashes. Accepts bool or int.
        ruby19_syntax:     false,  # Use Ruby 1.9 hash syntax in output.
        class_name:        :class, # Method used to get Instance class name.
        object_id:         true,   # Show object_id.

        recursive_nesting:        true,   # Hide already displayed nested Hash / Array.
        display_object_reference: true, # Show object_id, mostly useful when hiding already displayed objects.

        color: {
          args:       MONOKAI_PRO[:base8],
          array:      MONOKAI_PRO[:base8],
          bigdecimal: MONOKAI_PRO[:purple],
          class:      [MONOKAI_PRO[:green], :italic],
          date:       MONOKAI_PRO[:purple],
          falseclass: MONOKAI_PRO[:purple],
          fixnum:     MONOKAI_PRO[:purple],
          integer:    MONOKAI_PRO[:purple],
          float:      MONOKAI_PRO[:purple],
          hash:       MONOKAI_PRO[:base8],
          keyword:    MONOKAI_PRO[:green],
          method:     MONOKAI_PRO[:base8],
          nilclass:   MONOKAI_PRO[:purple],
          proc:       [MONOKAI_PRO[:green], :italic],
          rational:   MONOKAI_PRO[:purple],
          string:     MONOKAI_PRO[:yellow],
          struct:     MONOKAI_PRO[:base8],
          symbol:     MONOKAI_PRO[:orange],
          time:       MONOKAI_PRO[:purple],
          trueclass:  MONOKAI_PRO[:purple],
          variable:   MONOKAI_PRO[:purple],

          object_reference: [MONOKAI_PRO[:base7], :italic],

          array_indices: [MONOKAI_PRO[:base6], :italic],
          array_syntax:  MONOKAI_PRO[:base6],

          hash_syntax:   MONOKAI_PRO[:base6],
          syntax:        MONOKAI_PRO[:base6],

          bold:       :bold,
          italic:     :italic,
          unknown:    '#ff2f2f',
        }
      }

      # Merge custom defaults and let explicit options parameter override them.
      merge_custom_defaults!
      merge_options!(options)

      @formatter = AwesomePrint::Formatter.new(self)
      @indentator = AwesomePrint::Indentator.new(@options[:indent].abs)

      Thread.current[APN]  ||= []
      Thread.current[APGN] ||= {}
    end

    def current_indentation
      indentator.indentation
    end

    def increase_indentation(&block)
      indentator.indent(&block)
    end

    # Dispatcher that detects data nesting and invokes object-aware formatter.
    #---------------------------------------------------------------------------
    def awesome(object, top_level = false)
      result            = nil
      current_object_id = object.object_id
      recursive_nesting = @options[:recursive_nesting]

      Thread.current[APGN] = {} if recursive_nesting && top_level

      if Thread.current[APN].include?(current_object_id) || (recursive_nesting && Thread.current[APGN][current_object_id] && (object.is_a?(::Hash) || object.is_a?(::Array))) || (object.respond_to?(:__ap_nest__) && object.__ap_nest__)
        result = nested(object)
      else
        begin
          Thread.current[APGN][current_object_id] = true if recursive_nesting
          Thread.current[APN] << current_object_id
          result = unnested(object)
        ensure
          Thread.current[APN].pop
        end
      end

      Thread.current[APGN].clear if recursive_nesting && top_level

      result
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
      current_object_id = object.object_id
      object_type       = printable(object)

      case object_type
      when :array, :hash, :struct
        object_class = object_type
      else
        if object.respond_to?(:'class=')
          object.class = object.class
        end
        object_type  = :class
      end

      object_name = object.respond_to?(:__ap_log_name__) ? object.send(:__ap_log_name__) : nil
      if object_name.respond_to?(:call)
        object_name = object_name.call(object)
      end

      str = "#<#{ object_class.to_s.capitalize }:#{ current_object_id }#{ object_name ? " #{ object_name }" : '' }>"
      @formatter.colorize(str, :object_reference)
    end

    #---------------------------------------------------------------------------
    def unnested(object)
      @formatter.format(object, printable(object))
    end

    # Turn class name into symbol, ex: Hello::World => :hello_world. Classes
    # that inherit from Array, Hash, File, Dir, and Struct are treated as the
    # base class.
    #---------------------------------------------------------------------------
    def self.printable(object)
      case object
      when Array  then :array
      when Hash   then :hash
      when File   then :file
      when Dir    then :dir
      when Struct then :struct
      when String then :string
      when Symbol then :symbol
      else object.class.to_s.gsub(/:+/, '_').downcase.to_sym
      end
    end

    def printable(object)
      self.class.printable(object)
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
