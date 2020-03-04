# Copyright (c) 2010-2016 Michael Dvorkin and contributors
#
# Awesome Print is freely distributable under the terms of MIT license.
# See LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
module AwesomerPrint
  module Logger

    # Add ap method to logger
    #------------------------------------------------------------------------------
    def ap(object, level = nil)
      level ||= AwesomerPrint.defaults[:log_level] if AwesomerPrint.defaults
      level ||= :debug
      send level, object.ai
    end
  end
end

Logger.send(:include, AwesomerPrint::Logger)
ActiveSupport::BufferedLogger.send(:include, AwesomerPrint::Logger) if defined?(ActiveSupport::BufferedLogger)
