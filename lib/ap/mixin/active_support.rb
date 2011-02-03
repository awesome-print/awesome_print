# Copyright (c) 2010-2011 Michael Dvorkin
#
# Awesome Print is freely distributable under the terms of MIT license.
# See LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
module AwesomePrintActiveSupport

  def self.included(base)
    base.send :alias_method, :printable_without_active_support, :printable
    base.send :alias_method, :printable, :printable_with_active_support
  end

  # Add ActiveSupport class names to the dispatcher pipeline.
  #------------------------------------------------------------------------------
  def printable_with_active_support(object)
    printable = printable_without_active_support(object)
    return printable if !defined?(ActiveSupport::TimeWithZone) || !defined?(HashWithIndifferentAccess)

    if printable == :self
      if object.is_a?(ActiveSupport::TimeWithZone)
        printable = :active_support_time
      elsif object.is_a?(HashWithIndifferentAccess)
        printable = :hash_with_indifferent_access
      end
    end
    printable
  end

  # Format ActiveSupport::TimeWithZone as standard Time.
  #------------------------------------------------------------------------------
  def awesome_active_support_time(object)
    awesome_self(object, :as => :time)
  end

  # Format HashWithIndifferentAccess as standard Hash.
  #
  # NOTE: can't use awesome_self(object, :as => :hash) since awesome_self uses
  # object.inspect internally, i.e. it would convert hash to string.
  #------------------------------------------------------------------------------
  def awesome_hash_with_indifferent_access(object)
    awesome_hash(object)
  end

end

AwesomePrint.send(:include, AwesomePrintActiveSupport)
