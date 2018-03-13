require_relative 'base_formatter'
require 'shellwords'

module AwesomePrint
  module Formatters
    class FileFormatter < BaseFormatter

      def file
        @object
      end

      def format
        ls = File.directory?(file) ? `ls -adlF #{file.path.shellescape}` : `ls -alF #{file.path.shellescape}`
        colorize(ls.empty? ? file.inspect : "#{file.inspect}\n#{ls.chop}", :file)
      end
    end
  end
end
