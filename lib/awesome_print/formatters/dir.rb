module AwesomePrint
  module Formatters
    class Dir < Base

      def call
        ls = `ls -alF #{object.path.shellescape}`
        formatter.colorize(ls.empty? ? object.inspect : "#{object.inspect}\n#{ls.chop}", :dir)
      end
    end
  end
end
