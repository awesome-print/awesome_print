module AwesomePrint
  module Formatters
    class ActiveSupportTime < Base

      def call
        formatter.colorize(object.inspect, :time)
      end
    end
  end
end
