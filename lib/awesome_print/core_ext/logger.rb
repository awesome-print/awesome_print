module AwesomePrint
  module Logger

    # Add ap method to logger
    #------------------------------------------------------------------------------
    def ap(object, level = nil)
      level ||= AwesomePrint.defaults[:log_level] if AwesomePrint.defaults
      level ||= :debug
      send level, object.ai
    end
  end
end

Logger.send(:include, AwesomePrint::Logger) if defined?(Logger)
ActiveSupport::BufferedLogger.send(:include, AwesomePrint::Logger) if defined?(ActiveSupport::BufferedLogger)
