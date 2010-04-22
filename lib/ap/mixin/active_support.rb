# Copyright (c) 2010 Michael Dvorkin
#
# Awesome Print is freely distributable under the terms of MIT license.
# See LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
module AwesomePrintActiveSupport

  def self.included(base)
    base.alias_method_chain :printable, :active_support
  end

  # Add ActiveSupport class names to the dispatcher pipeline.
  #------------------------------------------------------------------------------
  def printable_with_active_support(object)
    printable = printable_without_active_support(object)
    if printable == :self
      if object.is_a?(ActiveSupport::TimeWithZone)
        printable = :active_support_time
      end
    end
    printable
  end

  # Format ActiveSupport::TimeWithZone as standard Time.
  #------------------------------------------------------------------------------
  def awesome_active_support_time(object)
    awesome_self(object, :as => :time)
  end

end

AwesomePrint.send(:include, AwesomePrintActiveSupport)
