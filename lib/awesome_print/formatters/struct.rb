module AwesomePrint
  module Formatters
    class Struct < Base
      #
      # The code is slightly uglier because of Ruby 1.8.6 quirks:
      # awesome_hash(Hash[s.members.zip(s.values)]) <-- ArgumentError: odd number of arguments for Hash)
      # awesome_hash(Hash[*s.members.zip(s.values).flatten]) <-- s.members returns strings, not symbols.
      #
      def call
        hash = {}
        object.each_pair { |key, value| hash[key] = value }
        AwesomePrint::Formatters::Hash.new(formatter, hash).call
      end
    end
  end
end
