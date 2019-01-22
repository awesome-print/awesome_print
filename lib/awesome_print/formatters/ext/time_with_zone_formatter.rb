require_relative '../base_formatter'
require 'date'

module AwesomePrint
  module Formatters
    class TimeWithZoneFormatter < BaseFormatter

      formatter_for :time_with_zone

      def self.formattable?(object)
        (defined?(::ActiveSupport::TimeWithZone) && object.is_a?(::ActiveSupport::TimeWithZone)) ||
          object.is_a?(::DateTime) || Object.is_a?(::Time)
      end

      def format(object)
        colorize(object.inspect, :time)
      end

    end
  end
end
