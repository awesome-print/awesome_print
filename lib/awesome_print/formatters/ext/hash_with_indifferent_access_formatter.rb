require_relative '../hash_formatter'

module AwesomePrint
  module Formatters
    class HashWithIndifferentAccessFormatter < HashFormatter

      formatter_for :hash_with_indifferent_access

      def self.core?
        false
      end

      def self.formattable?(object)
        defined?(::HashWithIndifferentAccess) &&
          object.is_a?(::HashWithIndifferentAccess)
      end

    end
  end
end
