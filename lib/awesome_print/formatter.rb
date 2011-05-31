# Copyright (c) 2010-2011 Michael Dvorkin
#
# Awesome Print is freely distributable under the terms of MIT license.
# See LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
require "cgi"
require "shellwords"

module AwesomePrint
  class Formatter

    CORE = [ :array, :hash, :class, :file, :dir, :bigdecimal, :rational, :struct, :method, :unboundmethod ]

    def initialize(inspector)
      @inspector   = inspector
      @options     = inspector.options
      @indentation = @options[:indent].abs
    end

    # Main entry point to format an object.
    #------------------------------------------------------------------------------
    def format(object, type = nil)
      core_class = cast(object, type)
      return send(:"awesome_#{core_class}", object) if core_class != :self
      awesome_self(object, :as => type) # Catch all that falls back on object.inspect.
    end

    # Hook this when adding custom formatters.
    #------------------------------------------------------------------------------
    def cast(object, type)
      CORE.grep(type)[0] || :self
    end

    # Pick the color and apply it to the given string as necessary.
    #------------------------------------------------------------------------------
    def colorize(s, type)
      s = CGI.escapeHTML(s) if @options[:html]
      if @options[:plain] || !@options[:color][type] || !@inspector.colorize?
        @options[:html] ? "<pre>#{s}</pre>" : s
      else
        s.send(@options[:color][type], @options[:html])
      end
    end


    private

    # Catch all method to format an arbitrary object.
    #------------------------------------------------------------------------------
    def awesome_self(object, appear = {})
      return awesome_object(object) if object.instance_variables.any?
      colorize(object.inspect.to_s, appear[:as])
    end

    # Format an array.
    #------------------------------------------------------------------------------
    def awesome_array(a)
      return "[]" if a == []

      if a.instance_variable_defined?('@__awesome_methods__')
        methods_array(a)
      elsif @options[:multiline]
        width = (a.size - 1).to_s.size 

        data = a.inject([]) do |arr, item|
          index = indent
          index << colorize("[#{arr.size.to_s.rjust(width)}] ", :array) if @options[:index]
          indented do
            arr << (index << @inspector.awesome(item))
          end
        end

        data = limited(data, width) if should_be_limited?
        "[\n" << data.join(",\n") << "\n#{outdent}]"
      else
        "[ " << a.map{ |item| @inspector.awesome(item) }.join(", ") << " ]"
      end
    end

    # Format a hash. If @options[:indent] if negative left align hash keys.
    #------------------------------------------------------------------------------
    def awesome_hash(h)
      return "{}" if h == {}

      keys = @options[:sort_keys] ? h.keys.sort { |a, b| a.to_s <=> b.to_s } : h.keys
      data = keys.map do |key|
        plain_single_line do
          [ @inspector.awesome(key), h[key] ]
        end
      end
      
      width = data.map { |key, | key.size }.max || 0
      width += @indentation if @options[:indent] > 0
  
      data = data.map do |key, value|
        indented do
          align(key, width) << colorize(" => ", :hash) << @inspector.awesome(value)
        end
      end

      data = limited(data, width, true) if should_be_limited?
      if @options[:multiline]
        "{\n" << data.join(",\n") << "\n#{outdent}}"
      else
        "{ #{data.join(', ')} }"
      end
    end

    # Format an object.
    #------------------------------------------------------------------------------
    def awesome_object(o)
      vars = o.instance_variables.map do |var|
        property = var[1..-1].to_sym
        accessor = if o.respond_to?(:"#{property}=")
          o.respond_to?(property) ? :accessor : :writer
        else
          o.respond_to?(property) ? :reader : nil
        end
        if accessor
          [ "attr_#{accessor} :#{property}", var ]
        else
          [ var.to_s, var ]
        end
      end

      width = vars.map { |declaration,| declaration.size }.max || 0
      width += @indentation if @options[:indent] > 0

      data = vars.sort.map do |declaration, var|
        key = align(declaration, width)
        unless @options[:plain]
          if key =~ /(@\w+)/
            key.sub!($1, colorize($1, :variable))
          else
            key.sub!(/(attr_\w+)\s(\:\w+)/, "#{colorize('\\1', :keyword)} #{colorize('\\2', :method)}")
          end
        end
        indented do
          key << colorize(" = ", :hash) + @inspector.awesome(o.instance_variable_get(var))
        end
      end
      if @options[:multiline]
        "#<#{awesome_instance(o)}\n#{data.join(%Q/,\n/)}\n#{outdent}>"
      else
        "#<#{awesome_instance(o)} #{data.join(', ')}>"
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
        colorize("#{c.inspect} < #{superclass}", :class)
      else
        colorize(c.inspect, :class)
      end
    end

    # Format File object.
    #------------------------------------------------------------------------------
    def awesome_file(f)
      ls = File.directory?(f) ? `ls -adlF #{f.path.shellescape}` : `ls -alF #{f.path.shellescape}`
      colorize(ls.empty? ? f.inspect : "#{f.inspect}\n#{ls.chop}", :file)
    end

    # Format Dir object.
    #------------------------------------------------------------------------------
    def awesome_dir(d)
      ls = `ls -alF #{d.path.shellescape}`
      colorize(ls.empty? ? d.inspect : "#{d.inspect}\n#{ls.chop}", :dir)
    end

    # Format BigDecimal and Rational objects by convering them to Float.
    #------------------------------------------------------------------------------
    def awesome_bigdecimal(n)
      colorize(n.to_f.inspect, :bigdecimal)
    end
    alias :awesome_rational :awesome_bigdecimal

    # Format a method.
    #------------------------------------------------------------------------------
    def awesome_method(m)
      name, args, owner = method_tuple(m)
      "#{colorize(owner, :class)}##{colorize(name, :method)}#{colorize(args, :args)}"
    end
    alias :awesome_unboundmethod :awesome_method

    # Format object instance.
    #------------------------------------------------------------------------------
    def awesome_instance(o)
      "#{o.class}:0x%08x" % (o.__id__ * 2)
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
        index = indent
        index << "[#{arr.size.to_s.rjust(width)}]" if @options[:index]
        indented do
          arr << "#{index} #{colorize(item[0].rjust(name_width), :method)}#{colorize(item[1].ljust(args_width), :args)} #{colorize(item[2], :class)}"
        end
      end

      "[\n" << data.join("\n") << "\n#{outdent}]"
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

    # Utility methods.
    #------------------------------------------------------------------------------
    def align(value, width)
      if @options[:multiline]
        if @options[:indent] >= 0
          value.rjust(width)
        else
          indent + value.ljust(width)
        end
      else
        value
      end
    end

    def indented
      @indentation += @options[:indent].abs
      yield
    ensure
      @indentation -= @options[:indent].abs
    end

    def indent
      ' ' * @indentation
    end

    def outdent
      ' ' * (@indentation - @options[:indent].abs)
    end

    # To support limited output.
    #------------------------------------------------------------------------------
    def should_be_limited?
      @options[:limit] or (@options[:limit].class == Fixnum and @options[:limit] > 0)
    end

    def get_limit_size
      return @options[:limit] if @options[:limit].class == Fixnum
      return AwesomePrint::Inspector::DEFAULT_LIMIT_SIZE
    end

    def limited(data, width, is_hash = false)
      if data.length <= get_limit_size
        data
      else
        # Calculate how many elements to be displayed above and below the
        # separator.
        diff = get_limit_size - 1
        es = (diff / 2).floor
        ss = (diff % 2 == 0) ? es : es + 1

        # In the temp data array, add the proper elements and then return.
        temp = Array.new(get_limit_size)
        temp[0, ss]   = data[0, ss]
        temp[-es, es] = data[-es, es]

        if is_hash
          temp[ss] = "#{indent}#{data[ss].strip} .. #{data[data.length - es - 1].strip}"
        else
          temp[ss] = "#{indent}[#{ss.to_s.rjust(width)}] .. [#{data.length - es - 1}]"
        end

        temp
      end
    end

  end
end
