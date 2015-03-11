module AwesomePrint
  module Formatters
    class Method < Base

      def call
        name, args, owner = formatter.method_tuple(object)
        "#{formatter.colorize(owner, :class)}##{formatter.colorize(name, :method)}#{formatter.colorize(args, :args)}"
      end
    end
  end
end
