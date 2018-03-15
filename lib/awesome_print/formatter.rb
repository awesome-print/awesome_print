# Copyright (c) 2010-2016 Michael Dvorkin and contributors
#
# Awesome Print is freely distributable under the terms of MIT license.
# See LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
require 'awesome_print/formatters'
require 'set'

module AwesomePrint
  class Formatter
    include Colorize

    attr_reader :inspector, :options

    CORE = Set.new [:array, :bigdecimal, :class, :dir, :file, :hash, :method, :rational, :set, :struct, :unboundmethod]

    def initialize(inspector)
      @inspector   = inspector
      @options     = inspector.options
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
    def cast(_object, type)
      CORE.include?(type) ? type : :self
    end

    private

    # Catch all method to format an arbitrary object.
    #------------------------------------------------------------------------------
    def awesome_self(object, type)
      if @options[:raw] && object.instance_variables.any?
        awesome_object(object)
      elsif (hash = convert_to_hash(object))
        awesome_hash(hash)
      else
        awesome_simple(object.inspect.to_s, type, @inspector)
      end
    end

    def awesome_bigdecimal(n)
      o = n.to_s('F')
      type = :bigdecimal
      awesome_simple(o, type, @inspector)
    end

    def awesome_rational(n)
      o = n.to_s
      type = :rational
      awesome_simple(o, type, @inspector)
    end

    def awesome_simple(o, type, inspector = @inspector)
      AwesomePrint::Formatters::SimpleFormatter.new(o, type, inspector).format
    end

    def awesome_array(a)
      @array_formatter ||= Formatters::ArrayFormatter.new(:__placeholder,  @inspector)
      @array_formatter.format_object(a)
    end

    def awesome_set(s)
      @array_formatter ||= Formatters::ArrayFormatter.new(:__placeholder, @inspector)
      @array_formatter.format_object(s.to_a)
    end

    def awesome_hash(h)
      @hash_formatter ||= Formatters::HashFormatter.new(:__placeholder, @inspector)
      @hash_formatter.format_object(h)
    end

    def awesome_object(o)
      @object_formatter ||= Formatters::ObjectFormatter.new(:__placeholder, @inspector)
      @object_formatter.format_object(o)
    end

    def awesome_struct(s)
      @struct_formatter ||= Formatters::StructFormatter.new(:__placeholder, @inspector)
      @struct_formatter.format_object(s)
    end

    def awesome_method(m)
      @method_formatter ||= Formatters::MethodFormatter.new(:__placeholder, @inspector)
      @method_formatter.format_object(m)
    end
    alias :awesome_unboundmethod :awesome_method

    def awesome_class(c)
      @class_formatter ||= Formatters::ClassFormatter.new(:__placeholder, @inspector)
      @class_formatter.format_object(c)
    end

    def awesome_file(f)
      @file_formatter ||= Formatters::FileFormatter.new(:__placeholder, @inspector)
      @file_formatter.format_object(f)
    end

    def awesome_dir(d)
      @dir_formatter ||= Formatters::DirFormatter.new(:__placeholder, @inspector)
      @dir_formatter.format_object(d)
    end

    # Utility methods.
    #------------------------------------------------------------------------------
    def convert_to_hash(object)
      if !object.respond_to?(:to_hash)
        return nil
      end

      begin
        obj = object.to_hash
        return obj if obj.is_a? Hash
      rescue ArgumentError
        return nil
      end

      nil
    end
  end
end
