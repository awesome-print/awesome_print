# Copyright (c) 2010-2011 Michael Dvorkin
#
# Awesome Print is freely distributable under the terms of MIT license.
# See LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
module AwesomePrintLogger

  # Add ap method to logger
  #------------------------------------------------------------------------------
  def ap(object, level = nil)
    level ||= AwesomePrint.defaults[:log_level] || :debug
    send level, object.ai
  end

end

Logger.send(:include, AwesomePrintLogger)
ActiveSupport::BufferedLogger.send(:include, AwesomePrintLogger) if defined?(::ActiveSupport::BufferedLogger)
