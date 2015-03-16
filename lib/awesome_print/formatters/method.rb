require 'awesome_print/formatters/method_tuple'

module AwesomePrint
  module Formatters
    class Method < Base
      include MethodTuple

      def call
        name, args, owner = method_tuple(object)
        "#{formatter.colorize(owner, :class)}##{formatter.colorize(name, :method)}#{formatter.colorize(args, :args)}"
      end
    end
  end
end
