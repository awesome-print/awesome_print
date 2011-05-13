# Copyright (c) 2010-2011 Michael Dvorkin
#
# Awesome Print is freely distributable under the terms of MIT license.
# See LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
require "cgi"
require "shellwords"

class AwesomePrint
  AP = :__awesome_print__ unless defined?(AwesomePrint::AP)
  CORE = [ :array, :hash, :class, :file, :dir, :bigdecimal, :rational, :struct, :method, :unboundmethod ] unless defined?(AwesomePrint::CORE)
  @@force_colors = false

  def initialize(options = {})
    @options = { 
      :multiline => true,           # Display in multiple lines.
      :plain     => false,          # Use colors.
      :indent    => 4,              # Indent using 4 spaces.
      :index     => true,           # Display array indices.
      :html      => false,          # Use ANSI color codes rather than HTML.
      :sorted_hash_keys => false,   # Do not sort hash keys.
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
        :trueclass  => :green,
        :method     => :purpleish,
        :args       => :pale
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

    if a.instance_variable_defined?('@__awesome_methods__')
      methods_array(a)
    elsif @options[:multiline]
      width = (a.size - 1).to_s.size 
      data = a.inject([]) do |arr, item|
        index = if @options[:index]
          colorize("#{indent}[#{arr.size.to_s.rjust(width)}] ", :array)
        else
          colorize(indent, :array)
        end
        indented do
          arr << (index << awesome(item))
        end
      end
      "[\n" << data.join(",\n") << "\n#{outdent}]"
    else
      "[ " << a.map{ |item| awesome(item) }.join(", ") << " ]"
    end
  end

  # Format a hash. If @options[:indent] if negative left align hash keys.
  #------------------------------------------------------------------------------
  def awesome_hash(h)
    return "{}" if h == {}

    keys = @options[:sorted_hash_keys] ? h.keys.sort { |a, b| a.to_s <=> b.to_s } : h.keys
    data = keys.map do |key|
      plain_single_line do
        [ awesome(key), h[key] ]
      end
    end
      
    width = data.map { |key, | key.size }.max || 0
    width += @indentation if @options[:indent] > 0
  
    data = data.map do |key, value|
      if @options[:multiline]
        formatted_key = (@options[:indent] >= 0 ? key.rjust(width) : indent + key.ljust(width))
      else
        formatted_key = key
      end
      indented do
        formatted_key << colorize(" => ", :hash) << awesome(value)
      end
    end
    if @options[:multiline]
      "{\n" << data.join(",\n") << "\n#{outdent}}"
    else
      "{ #{data.join(', ')} }"
    end
  end

  # Format a Struct. If @options[:indent] is negative left align hash keys.
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

  # Format a method.
  #------------------------------------------------------------------------------
  def awesome_method(m)
    name, args, owner = method_tuple(m)
    "#{colorize(owner, :class)}##{colorize(name, :method)}#{colorize(args, :args)}"
  end
  alias :awesome_unboundmethod :awesome_method

  # Catch all method to format an arbitrary object.
  #------------------------------------------------------------------------------
  def awesome_self(object, appear = {})
    colorize(object.inspect.to_s << appear[:with].to_s, appear[:as] || declassify(object))
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

  # Format object.methods array.
  #------------------------------------------------------------------------------
  def methods_array(a)
    object = a.instance_variable_get('@__awesome_methods__')
    tuples = a.map do |name|
      tuple = if object.respond_to?(name, true)         # Is this a regular method?
        the_method = object.method(name) rescue nil     # Avoid potential ArgumentError if object#method is overridden.
        if the_method && the_method.respond_to?(:arity) # Is this original object#method?
          method_tuple(the_method)                      # Yes, we are good.
        end
      elsif object.respond_to?(:instance_method)        # Is this an unbound method?
        method_tuple(object.instance_method(name))
      end
      tuple || [ name.to_s, '(?)', '' ]                 # Return WTF default if all the above fails.
    end

    width = (tuples.size - 1).to_s.size
    name_width = tuples.map { |item| item[0].size }.max || 0
    args_width = tuples.map { |item| item[1].size }.max || 0

    data = tuples.inject([]) do |arr, item|
      index = if @options[:index]
        "#{indent}[#{arr.size.to_s.rjust(width)}]"
      else
        indent
      end
      indented do
        arr << "#{index} #{colorize(item[0].rjust(name_width), :method)}#{colorize(item[1].ljust(args_width), :args)} #{colorize(item[2], :class)}"
      end
    end

    "[\n" << data.join("\n") << "\n#{outdent}]"
  end

  # Format nested data, for example:
  #   arr = [1, 2]; arr << arr
  #   => [1,2, [...]]
  #   hsh = { :a => 1 }; hsh[:b] = hsh
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

  # Return one of the "core" types that have a formatter of :self otherwise.
  #------------------------------------------------------------------------------
  def printable(object)
    CORE.grep(declassify(object))[0] || :self
  end

  # Turn class name into symbol, ex: Hello::World => :hello_world. Classes that
  # inherit from Array, Hash, File, Dir, and Struct are treated as the base class.
  #------------------------------------------------------------------------------
  def declassify(object)
    case object
    when Array  then :array
    when Hash   then :hash
    when File   then :file
    when Dir    then :dir
    when Struct then :struct
    else object.class.to_s.gsub(/:+/, "_").downcase.to_sym
    end
  end

  # Pick the color and apply it to the given string as necessary.
  #------------------------------------------------------------------------------
  def colorize(s, type)
    s = CGI.escapeHTML(s) if @options[:html]
    if @options[:plain] || !@options[:color][type] || !colorize?
      @options[:html] ? "<pre>#{s}</pre>" : s
    else
      s.send(@options[:color][type], @options[:html])
    end
  end

  # Return [ name, arguments, owner ] tuple for a given method.
  #------------------------------------------------------------------------------
  def method_tuple(method)
    if method.respond_to?(:parameters) # Ruby 1.9.2+
      # See http://ruby.runpaint.org/methods#method-objects-parameters
      args = method.parameters.inject([]) do |arr, (type, name)|
        name ||= (type == :block ? 'block' : "arg#{arr.size + 1}")
        arr << case type
          when :req        then name.to_s
          when :opt, :rest then "*#{name}"
          when :block      then "&#{name}"
          else '?'
        end
      end
    else # See http://ruby-doc.org/core/classes/Method.html#M001902
      args = (1..method.arity.abs).map { |i| "arg#{i}" }
      args[-1] = "*#{args[-1]}" if method.arity < 0
    end

    if method.to_s =~ /(Unbound)*Method: (.*?)[#\.]/
      owner = "#{$2}#{$1 ? '(unbound)' : ''}".gsub('(', ' (')
    end

    [ method.name.to_s, "(#{args.join(', ')})", owner.to_s ]
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

  # Return true if we are to colorize the output.
  #------------------------------------------------------------------------------
  def colorize?
    @@force_colors || (STDOUT.tty? && ((ENV['TERM'] && ENV['TERM'] != 'dumb') || ENV['ANSICON']))
  end

  # Class accessor to force colorized output (ex. forked subprocess where TERM
  # might be dumb).
  #------------------------------------------------------------------------------
  def self.force_colors!(value = true)
    @@force_colors = value
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
