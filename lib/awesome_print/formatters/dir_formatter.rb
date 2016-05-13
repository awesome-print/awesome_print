require_relative 'base_formatter'
require "shellwords"

module AwesomePrint
  module Formatters
    class DirFormatter < BaseFormatter

      attr_reader :dir, :inspector, :options, :indentation

      def initialize(dir, inspector)
        @dir = dir
        @inspector = inspector
        @options = inspector.options
        @indentation = @options[:indent].abs
      end

      def format
        ls = `ls -alF #{dir.path.shellescape}`
        colorize(ls.empty? ? dir.inspect : "#{dir.inspect}\n#{ls.chop}", :dir)
      end
    end
  end
end
