require_relative 'simple_formatter'

module AwesomePrint
  module Formatters
    class IntegerFormatter < SimpleFormatter

      formatter_for :integer

    end
  end
end
