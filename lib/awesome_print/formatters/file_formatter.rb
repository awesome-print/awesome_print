require_relative 'base_formatter'
require 'shellwords'

module AwesomePrint
  module Formatters
    class FileFormatter < BaseFormatter

      formatter_for :file

      def self.formattable?(object)
        object.is_a?(File)
      end

      def format(file)
        ls = File.directory?(file) ? `ls -adlF #{file.path.shellescape}` : `ls -alF #{file.path.shellescape}`
        colorize(ls.empty? ? file.inspect : "#{file.inspect}\n#{ls.chop}", :file)
      end
    end
  end
end
