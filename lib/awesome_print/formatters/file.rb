module AwesomePrint
  module Formatters
    class File < Formatter

      def call
        ls = ::File.directory?(object) ? `ls -adlF #{object.path.shellescape}` : `ls -alF #{object.path.shellescape}`
        formatter.colorize(ls.empty? ? object.inspect : "#{object.inspect}\n#{ls.chop}", :file)
      end
    end
  end
end
