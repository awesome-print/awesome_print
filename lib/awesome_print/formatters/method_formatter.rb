require_relative 'base_formatter'

module AwesomePrint
  module Formatters
    class MethodFormatter < BaseFormatter

      attr_reader :method, :inspector, :options

      def initialize(method, inspector)
        @method    = method
        @inspector = inspector
        @options   = inspector.options
      end

      def format
        #name, args, owner = method_tuple(method)
        #{}"#<#{ colorize(owner, :class) }##{ colorize(name, :method) }#{ colorize(args, :args) }>"

        owner = method.receiver.to_s
        name  = method.name

        [
          colorize("#<#{ owner }.", :proc),
          colorize(name, [:method, :italic]),
          colorize(">", :proc),
        ].join('')
      end
    end
  end
end
