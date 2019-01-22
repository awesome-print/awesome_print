require_relative 'base_formatter'
require 'shellwords'

module AwesomePrint
  module Formatters
    class DirFormatter < BaseFormatter

      formatter_for :dir

      def self.formattable?(object)
        object.is_a?(Dir)
      end

      def format(dir)
        ls = `ls -alF #{dir.path.shellescape}`
        colorize(ls.empty? ? dir.inspect : "#{dir.inspect}\n#{ls.chop}", :dir)
      end
    end
  end
end
