module AwesomePrint
  module Formatters
    module MethodTuple

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
    end
  end
end
