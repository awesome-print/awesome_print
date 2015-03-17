if defined?(ActiveSupport::LogSubscriber)
  AwesomePrint.force_colors! ActiveSupport::LogSubscriber.colorize_logging
end

module AwesomePrint
  module Types
    class ActiveSupport < Base

      def call
        if (defined?(::ActiveSupport::TimeWithZone) && object.is_a?(::ActiveSupport::TimeWithZone)) || object.is_a?(::Date)
          :active_support_time
        elsif object.is_a?(::HashWithIndifferentAccess)
          :hash_with_indifferent_access
        end
      end
    end
  end
end
