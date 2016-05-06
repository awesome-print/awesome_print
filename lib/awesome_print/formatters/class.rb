module AwesomePrint
  module Formatters
    class Class < Formatter

      def call
        if superclass = object.superclass # <-- Assign and test if nil.
          formatter.colorize("#{object.inspect} < #{superclass}", :class)
        else
          formatter.colorize(object.inspect, :class)
        end
      end
    end
  end
end
