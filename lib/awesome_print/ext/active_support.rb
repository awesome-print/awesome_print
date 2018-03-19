# Copyright (c) 2010-2016 Michael Dvorkin and contributors
#
# Awesome Print is freely distributable under the terms of MIT license.
# See LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
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
        elsif defined?(::ActionController::Parameters) && object.is_a?(::ActionController::Parameters)
          cast = :action_controller_parameters
        end
      end
      cast
    end

    # Format ActiveSupport::TimeWithZone as standard Time.
    #------------------------------------------------------------------------------
    def awesome_active_support_time(object)
      colorize(object.inspect, :time)
    end

    # Format HashWithIndifferentAccess as standard Hash.
    #------------------------------------------------------------------------------
    def awesome_hash_with_indifferent_access(object)
      awesome_hash(object)
    end

    # Format ActionController::Parameters as standard Hash.
    #------------------------------------------------------------------------------
    def awesome_action_controller_parameters(object)
      awesome_hash(object.to_unsafe_h)
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

