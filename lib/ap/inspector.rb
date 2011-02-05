# Copyright (c) 2010-2011 Michael Dvorkin
#
# Awesome Print is freely distributable under the terms of MIT license.
# See LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
module AwesomePrint

  class << self # Class accessors for custom defaults.
    attr_accessor :defaults
  end

  class Inspector
    attr_accessor :options

    AP = :__awesome_print__

    def initialize(options = {})
      @options = { 
        :color => { 
          :array      => :white,
          :bigdecimal => :blue,
          :class      => :yellow,
          :date       => :greenish,
          :falseclass => :red,
          :fixnum     => :blue,
          :float      => :blue,
          :hash       => :pale,
          :struct     => :pale,
          :nilclass   => :red,
          :string     => :yellowish,
          :symbol     => :cyanish,
          :time       => :greenish,
          :trueclass  => :green,
          :method     => :purpleish,
          :args       => :pale
        },
        :indent    => 4,
        :index     => true,
        :multiline => true,
        :plain     => false,
        :sort_keys => false
      }

      # Merge custom defaults and let explicit options parameter override them.
      merge_custom_defaults!
      merge_options!(options)

      @formatter = AwesomePrint::Formatter.new(self)
      Thread.current[AP] ||= []
    end
  
    private

    # Dispatcher that detects data nesting and invokes object-aware formatter.
    #------------------------------------------------------------------------------
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

    # Format nested data, for example:
    #   arr = [1, 2]; arr << arr
    #   => [1,2, [...]]
    #   hash = { :a => 1 }; hash[:b] = hash
    #   => { :a => 1, :b => {...} }
    #------------------------------------------------------------------------------
    def nested(object)
      case printable(object)
        when :array  then @formatter.colorize("[...]", :array)
        when :hash   then @formatter.colorize("{...}", :hash)
        when :struct then @formatter.colorize("{...}", :struct)
        else @formatter.colorize("...#{object.class}...", :class)
      end
    end

    #------------------------------------------------------------------------------
    def unnested(object)
      @formatter.format(object, printable(object))
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
      if File.readable?(dotfile)
        load dotfile
        merge_options!(AwesomePrint.defaults)
      end
    rescue => e
      $stderr.puts "Could not load #{dotfile}: #{e}"
    end
  end
end
