module AwesomePrint
  module Formatters
    class Object < Base

      def call
        build_vars
        build_data
        if options[:multiline]
          inline_format
        else
          multiline_format
        end
      end

      private

        def build_vars
          @vars = object.instance_variables.map do |var|
            property = var.to_s[1..-1].to_sym # to_s because of some monkey patching done by Puppet.
            accessor = if object.respond_to?(:"#{property}=")
                         object.respond_to?(property) ? :accessor : :writer
                       else
                         object.respond_to?(property) ? :reader : nil
                       end
            if accessor
              [ "attr_#{accessor} :#{property}", var ]
            else
              [ var.to_s, var ]
            end
          end
        end

        def build_data
          @data = @vars.sort.map do |declaration, var|
            key = formatter.left_aligned do
              formatter.align(declaration, declaration.size)
            end

            unless options[:plain]
              if key =~ /(@\w+)/
                key.sub!($1, formatter.colorize($1, :variable))
              else
                key.sub!(/(attr_\w+)\s(\:\w+)/, "#{formatter.colorize('\\1', :keyword)} #{formatter.colorize('\\2', :method)}")
              end
            end
            formatter.indented do
              key << formatter.colorize(" = ", :hash) + inspector.awesome(object.instance_variable_get(var))
            end
          end
        end

        def inline_format
          "#<#{formatter.awesome_instance(object)}\n#{@data.join(%Q/,\n/)}\n#{formatter.outdent}>"
        end

        def multiline_format
          "#<#{formatter.awesome_instance(object)} #{@data.join(', ')}>"
        end
    end
  end
end
