# Copyright (c) 2010 Michael Dvorkin
#
# Awesome Print is freely distributable under the terms of MIT license.
# See LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
module AwesomePrintRails

  def self.included(base)
    base.alias_method_chain :printable, :rails
  end

  # Add ActiveRecord class names to the dispatcher pipeline.
  #------------------------------------------------------------------------------
  def printable_with_rails(object)
    printable = printable_without_rails(object)
    if printable == :self
      if object.is_a?(ActiveRecord::Base)
        printable = :active_record_instance
      elsif object.is_a?(ActiveSupport::TimeWithZone)
        printable = :active_support_time
      end
    elsif printable == :class && object.class.is_a?(ActiveRecord::Base.class)
      printable = :active_record_class
    end
    printable
  end

  # Format ActiveRecord instance object.
  #------------------------------------------------------------------------------
  def awesome_active_record_instance(object)
    data = object.class.column_names.inject(ActiveSupport::OrderedHash.new) do |hash, name|
      hash[name.to_sym] = object.send(name) if object.has_attribute?(name) || object.new_record?
      hash
    end
    "#{object} " + awesome_hash(data)
  end

  # Format ActiveRecord class object.
  #------------------------------------------------------------------------------
  def awesome_active_record_class(object)
    if object.respond_to?(:columns)
      data = object.columns.inject(ActiveSupport::OrderedHash.new) do |hash, c|
        hash[c.name.to_sym] = c.type
        hash
      end
      "class #{object} < #{object.superclass} " << awesome_hash(data)
    else
      object.inspect
    end
  end

  # Format ActiveSupport::TimeWithZone as standard Time.
  #------------------------------------------------------------------------------
  def awesome_active_support_time(object)
    awesome_self(object, :as => :time)
  end

end

AwesomePrint.send(:include, AwesomePrintRails)
