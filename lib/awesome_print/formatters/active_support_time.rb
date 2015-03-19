module AwesomePrint
  module Formatters
    class ActiveSupportTime < Formatter

      def call
        formatter.colorize(object.inspect, :time)
      end
    end
  end
end
