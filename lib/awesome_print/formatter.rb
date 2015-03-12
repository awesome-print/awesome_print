autoload :CGI, 'cgi'
require 'shellwords'
require 'awesome_print/formatters'

module AwesomePrint
  class Formatter

    CORE = [ :array, :bigdecimal, :class, :dir, :file, :hash, :method, :rational, :set, :struct, :unboundmethod ]
    DEFAULT_LIMIT_SIZE = 7

    attr_reader :options, :inspector, :indentation

    def initialize(inspector)
      @inspector   = inspector
      @options     = inspector.options
      @indentation = @options[:indent].abs
    end

    # Main entry point to format an object.
    #------------------------------------------------------------------------------
    def format(object, type = nil)
      core_class = cast(object, type)
      awesome = if core_class != :self
        send(:"awesome_#{core_class}", object) # Core formatters.
      else
        awesome_self(object, type) # Catch all that falls back to object.inspect.
      end
      awesome
    end

    # Hook this when adding custom formatters. Check out lib/awesome_print/ext
    # directory for custom formatters that ship with awesome_print.
    #------------------------------------------------------------------------------
    def cast(object, type)
      CORE.grep(type)[0] || :self
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

      # method.to_s formats to handle:
      #
      # #<Method: Fixnum#zero?>
      # #<Method: Fixnum(Integer)#years>
      # #<Method: User(#<Module:0x00000103207c00>)#_username>
      # #<Method: User(id: integer, username: string).table_name>
      # #<Method: User(id: integer, username: string)(ActiveRecord::Base).current>
      # #<UnboundMethod: Hello#world>
      #
      if method.to_s =~ /(Unbound)*Method: (.*)[#\.]/
        unbound, klass = $1 && '(unbound)', $2
        if klass && klass =~ /(\(\w+:\s.*?\))/  # Is this ActiveRecord-style class?
          klass.sub!($1, '')                    # Yes, strip the fields leaving class name only.
        end
        owner = "#{klass}#{unbound}".gsub('(', ' (')
      end

      [ method.name.to_s, "(#{args.join(', ')})", owner.to_s ]
    end

    private

    # Catch all method to format an arbitrary object.
    #------------------------------------------------------------------------------
    def awesome_self(object, type)
      if @options[:raw] && object.instance_variables.any?
        return awesome_object(object)
      elsif hash = convert_to_hash(object)
        awesome_hash(hash)
      else
        colorize(object.inspect.to_s, type)
      end
    end

    # Format an array.
    #------------------------------------------------------------------------------
    def awesome_array(a)
      AwesomePrint::Formatters::Array.new(self, a).call
    end

    # Format a hash. If @options[:indent] if negative left align hash keys.
    #------------------------------------------------------------------------------
    def awesome_hash(h)
      AwesomePrint::Formatters::Hash.new(self, h).call
    end

    # Format an object.
    #------------------------------------------------------------------------------
    def awesome_object(o)
      AwesomePrint::Formatters::Object.new(self, o).call
    end

    # Format a set.
    #------------------------------------------------------------------------------
    def awesome_set(s)
      AwesomePrint::Formatters::Set.new(self, s).call
    end

    # Format a Struct.
    #------------------------------------------------------------------------------
    def awesome_struct(s)
      AwesomePrint::Formatters::Struct.new(self, s).call
    end

    # Format Class object.
    #------------------------------------------------------------------------------
    def awesome_class(c)
      AwesomePrint::Formatters::Class.new(self, c).call
    end

    # Format File object.
    #------------------------------------------------------------------------------
    def awesome_file(f)
      AwesomePrint::Formatters::File.new(self, f).call
    end

    # Format Dir object.
    #------------------------------------------------------------------------------
    def awesome_dir(d)
      AwesomePrint::Formatters::Dir.new(self, d).call
    end

    # Format BigDecimal object.
    #------------------------------------------------------------------------------
    def awesome_bigdecimal(n)
      AwesomePrint::Formatters::BigDecimal.new(self, n).call
    end

    # Format Rational object.
    #------------------------------------------------------------------------------
    def awesome_rational(n)
      AwesomePrint::Formatters::Rational.new(self, n).call
    end

    # Format a method.
    #------------------------------------------------------------------------------
    def awesome_method(m)
      AwesomePrint::Formatters::Method.new(self, m).call
    end
    alias :awesome_unboundmethod :awesome_method

    # Utility methods.
    #------------------------------------------------------------------------------
    def convert_to_hash(object)
      if ! object.respond_to?(:to_hash)
        return nil
      end
      if object.method(:to_hash).arity != 0
        return nil
      end

      hash = object.to_hash
      if ! hash.respond_to?(:keys) || ! hash.respond_to?('[]')
        return nil
      end

      return hash
    end
  end
end
