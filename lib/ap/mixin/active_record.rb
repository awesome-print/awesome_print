# Copyright (c) 2010-2011 Michael Dvorkin
#
# Awesome Print is freely distributable under the terms of MIT license.
# See LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
module AwesomePrintActiveRecord

  def self.included(base)
    base.send :alias_method, :printable_without_active_record, :printable
    base.send :alias_method, :printable, :printable_with_active_record
  end

  # Add ActiveRecord class names to the dispatcher pipeline.
  #------------------------------------------------------------------------------
  def printable_with_active_record(object)
    printable = printable_without_active_record(object)
    return printable if !defined?(ActiveRecord::Base)

    if printable == :self
      if object.is_a?(ActiveRecord::Base)
        printable = :active_record_instance
      end
    elsif printable == :class and object.ancestors.include?(ActiveRecord::Base)
      printable = :active_record_class
    end
    printable
  end

  # Format ActiveRecord instance object.
  #------------------------------------------------------------------------------
  def awesome_active_record_instance(object)
    return object.inspect if !defined?(ActiveSupport::OrderedHash)

    data = object.class.column_names.inject(ActiveSupport::OrderedHash.new) do |hash, name|
      hash[name.to_sym] = object.send(name) if object.has_attribute?(name) || object.new_record?
      hash
    end
    "#{object} " + awesome_hash(data)
  end

  # Format ActiveRecord class object.
  #------------------------------------------------------------------------------
  def awesome_active_record_class(object)
    return object.inspect if !defined?(ActiveSupport::OrderedHash) || !object.respond_to?(:columns)

    data = object.columns.inject(ActiveSupport::OrderedHash.new) do |hash, c|
      hash[c.name.to_sym] = c.type
      hash
    end
    "class #{object} < #{object.superclass} " << awesome_hash(data)
  end
end

AwesomePrint.send(:include, AwesomePrintActiveRecord)
