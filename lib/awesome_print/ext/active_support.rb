module AwesomePrint
  module ActiveSupport

    def self.included(base)
      base.send :alias_method, :cast_without_active_support, :cast
      base.send :alias_method, :cast, :cast_with_active_support
    end

    def cast_with_active_support(object, type)
      cast = cast_without_active_support(object, type)
      if defined?(::ActiveSupport) && defined?(::HashWithIndifferentAccess)
        if (defined?(::ActiveSupport::TimeWithZone) && object.is_a?(::ActiveSupport::TimeWithZone)) || object.is_a?(::Date)
          cast = :active_support_time
        elsif object.is_a?(::HashWithIndifferentAccess)
          cast = :hash_with_indifferent_access
        end
      end
      cast
    end
  end
end

AwesomePrint::Formatter.send(:include, AwesomePrint::ActiveSupport)
#
# Colorize Rails logs.
#
if defined?(ActiveSupport::LogSubscriber)
  AwesomePrint.force_colors! ActiveSupport::LogSubscriber.colorize_logging
end

