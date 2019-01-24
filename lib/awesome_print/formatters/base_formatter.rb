require_relative '../colorize'
require_relative '../limiter'
require_relative '../registrar'

module AwesomePrint
  module Formatters
    class BaseFormatter

      include Colorize
      include Registrar
      include Limiter

      attr_reader :object, :inspector, :options

      def self.formattable?(obj)
        false
      end

      def self.core?
        false
      end

      def initialize(inspector)
        @inspector = inspector
        @options = inspector.options
      end

      def format(object)
        raise NotImplementedError
      end

      def method_tuple(method)
        if method.respond_to?(:parameters) # Ruby 1.9.2+
          # See http://readruby.chengguangnan.com/methods#method-objects-parameters
          # (mirror: http://archive.is/XguCA#selection-3381.1-3381.11)
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
          unbound = $1 && '(unbound)'
          klass = $2
          if klass && klass =~ /(\(\w+:\s.*?\))/  # Is this ActiveRecord-style class?
            klass.sub!($1, '')                    # Yes, strip the fields leaving class name only.
          end
          owner = "#{klass}#{unbound}".gsub('(', ' (')
        end

        [method.name.to_s, "(#{args.join(', ')})", owner.to_s]
      end

      #
      # Indentation related methods
      # FIXME: move to Indentator?...
      #-----------------------------------------
      def indentation
        inspector.current_indentation
      end

      def indented
        inspector.increase_indentation(&Proc.new)
      end

      def indent
        ' ' * indentation
      end

      def outdent
        ' ' * (indentation - options[:indent].abs)
      end

      def align(value, width)
        if options[:multiline]
          if options[:indent] > 0
            value.rjust(width)
          elsif options[:indent] == 0
            indent + value.ljust(width)
          else
            indent[0, indentation + options[:indent]] + value.ljust(width)
          end
        else
          value
        end
      end

    end
  end
end
