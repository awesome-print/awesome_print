# Copyright (c) 2010 Michael Dvorkin
#
# Awesome Print is freely distributable under the terms of MIT license.
# See LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
require "shellwords"

class AwesomePrint
  AP = :__awesome_print__
  CORE = [ :array, :hash, :class, :file, :dir, :bigdecimal, :rational, :struct ]

  def initialize(options = {})
    @options = { 
      :multiline => true,
      :plain     => false,
      :indent    => 4,
      :color     => { 
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
        :trueclass  => :green
      }
    }

    # Merge custom defaults and let explicit options parameter override them.
    merge_custom_defaults!
    merge_options!(options)

    @indentation = @options[:indent].abs
    Thread.current[AP] ||= []
  end
  
  private

  # Format an array.
  #------------------------------------------------------------------------------
  def awesome_array(a)
    return "[]" if a == []

    if @options[:multiline]
      width = (a.size - 1).to_s.size 
      data = a.inject([]) do |arr, item|
        index = colorize("#{indent}[#{arr.size.to_s.rjust(width)}] ", :array)
        indented do
          arr << (index << awesome(item))
        end
      end
      "[\n" << data.join(",\n") << "\n#{outdent}]"
    else
      data = a.inject([]) { |arr, item| arr << awesome(item) }
      "[ #{data.join(', ')} ]"
    end
  end

  # Format a hash. If @options[:indent] if negative left align hash keys.
  #------------------------------------------------------------------------------
  def awesome_hash(h)
    return "{}" if h == {}

    data = h.keys.inject([]) do |arr, key|
      plain_single_line do
        arr << [ awesome(key), h[key] ]
      end
    end
      
    width = data.map { |key, | key.size }.max || 0
    width += @indentation if @options[:indent] > 0
  
    data = data.inject([]) do |arr, (key, value)|
      if @options[:multiline]
        formatted_key = (@options[:indent] >= 0 ? key.rjust(width) : indent + key.ljust(width))
      else
        formatted_key = key
      end
      indented do
        arr << (formatted_key << colorize(" => ", :hash) << awesome(value))
      end
    end
    if @options[:multiline]
      "{\n" << data.join(",\n") << "\n#{outdent}}"
    else
      "{ #{data.join(', ')} }"
    end
  end

  # Format a Struct. If @options[:indent] if negative left align hash keys.
  #------------------------------------------------------------------------------
  def awesome_struct(s)
    h = {}
    s.each_pair { |k,v| h[k] = v }
    awesome_hash(h)
  end

  # Format Class object.
  #------------------------------------------------------------------------------
  def awesome_class(c)
    if superclass = c.superclass # <-- Assign and test if nil.
      awesome_self(c, :with => " < #{superclass}")
    else
      awesome_self(c)
    end
  end

  # Format File object.
  #------------------------------------------------------------------------------
  def awesome_file(f)
    ls = File.directory?(f) ? `ls -adlF #{f.path.shellescape}` : `ls -alF #{f.path.shellescape}`
    awesome_self(f, :with => ls.empty? ? nil : "\n#{ls.chop}")
  end

  # Format Dir object.
  #------------------------------------------------------------------------------
  def awesome_dir(d)
    ls = `ls -alF #{d.path.shellescape}`
    awesome_self(d, :with => ls.empty? ? nil : "\n#{ls.chop}")
  end

  # Format BigDecimal and Rational objects by convering them to Float.
  #------------------------------------------------------------------------------
  def awesome_bigdecimal(n)
    awesome_self(n.to_f, :as => :bigdecimal)
  end
  alias :awesome_rational :awesome_bigdecimal

  # Catch all method to format an arbitrary object.
  #------------------------------------------------------------------------------
  def awesome_self(object, appear = {})
    colorize(object.inspect << appear[:with].to_s, appear[:as] || declassify(object))
  end

  # Dispatcher that detects data nesting and invokes object-aware formatter.
  #------------------------------------------------------------------------------
  def awesome(object)
    if Thread.current[AP].include?(object.object_id)
      nested(object)
    else
      begin
        Thread.current[AP] << object.object_id
        send(:"awesome_#{printable(object)}", object)
      ensure
        Thread.current[AP].pop
      end
    end
  end

  # Format nested data, for example:
  #   arr = [1, 2]; arr << arr
  #   => [1,2, [...]]
  #   hsh = { :a => 1 }; hsh[:b] = hsh
  #   => { :a => 1, :b => {...} }
  #------------------------------------------------------------------------------
  def nested(object)
    case printable(object)
      when :array then colorize("[...]", :array)
      when :hash  then colorize("{...}", :hash)
      when :struct then colorize("{...}", :struct)
      else colorize("...#{object.class}...", :class)
    end
  end

  # Return one of the "core" types that have a formatter of :self otherwise.
  #------------------------------------------------------------------------------
  def printable(object)
    CORE.grep(declassify(object))[0] || :self
  end

  # Turn class name into symbol, ex: Hello::World => :hello_world.
  #------------------------------------------------------------------------------
  def declassify(object)
    if object.class.to_s.downcase =~ /^struct/
      result = :struct
    else
      result = object.class.to_s.gsub(/:+/, "_").downcase.to_sym
    end
    result
  end

  # Pick the color and apply it to the given string as necessary.
  #------------------------------------------------------------------------------
  def colorize(s, type)
    if type && !type.to_s.empty?
      type = type.to_s.gsub(/^struct_.*/,'struct').to_sym
    end
    if @options[:plain] || @options[:color][type].nil?
      s
    else
      s.send(@options[:color][type])
    end
  end

  # Format hash keys as plain string regardless of underlying data type.
  #------------------------------------------------------------------------------
  def plain_single_line
    plain, multiline = @options[:plain], @options[:multiline]
    @options[:plain], @options[:multiline] = true, false
    yield
  ensure
    @options[:plain], @options[:multiline] = plain, multiline
  end

  #------------------------------------------------------------------------------
  def indented
    @indentation += @options[:indent].abs
    yield
  ensure
    @indentation -= @options[:indent].abs
  end

  def indent
    @indent = ' ' * @indentation
  end

  def outdent
    @outdent = ' ' * (@indentation - @options[:indent].abs)
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
      merge_options!(self.class.defaults)
    end
  rescue => e
    $stderr.puts "Could not load #{dotfile}: #{e}"
  end

  # Class accessors for custom defaults.
  #------------------------------------------------------------------------------
  def self.defaults
    @@defaults ||= {}
  end

  def self.defaults=(args = {})
    @@defaults = args
  end

end
