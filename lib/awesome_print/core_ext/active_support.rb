#
# Colorize Rails logs.
#
if defined?(ActiveSupport::LogSubscriber)
  AwesomePrint.force_colors! ActiveSupport::LogSubscriber.colorize_logging
end

