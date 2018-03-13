require_relative 'base_formatter'
require 'shellwords'

module AwesomePrint
  module Formatters
    class DirFormatter < BaseFormatter

      def dir
        @object
      end

      def format
        ls = `ls -alF #{dir.path.shellescape}`
        colorize(ls.empty? ? dir.inspect : "#{dir.inspect}\n#{ls.chop}", :dir)
      end
    end
  end
end
