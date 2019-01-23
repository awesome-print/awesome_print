require_relative '../base_formatter'
require 'date'

module AwesomePrint
  module Formatters
    class TimeWithZoneFormatter < BaseFormatter

      formatter_for :time_with_zone

      # FIXME: should date/time/datetime not become more formal core formatters
      # [maybe with tz info and other more useful things]?

      def self.formattable?(object)
        (defined?(::ActiveSupport::TimeWithZone) && object.is_a?(::ActiveSupport::TimeWithZone)) ||
          object.is_a?(::DateTime) || object.is_a?(::Time) || object.is_a?(::Date)
      end

      def format(object)
        colorize(object.inspect, :time)
      end

    end
  end
end
