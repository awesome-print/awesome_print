require_relative 'simple_formatter'

module AwesomePrint
  module Formatters
    class StringFormatter < SimpleFormatter

      formatter_for :string

    end
  end
end
