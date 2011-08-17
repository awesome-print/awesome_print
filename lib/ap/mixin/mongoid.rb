# Copyright (c) 2010-2011 Michael Dvorkin
#
# Awesome Print is freely distributable under the terms of MIT license.
# See LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
module AwesomePrintMongoid
  def self.included(base)
    base.send :alias_method, :printable_without_mongoid, :printable
    base.send :alias_method, :printable, :printable_with_mongoid
  end

  def printable_with_mongoid(object)
    printable = printable_without_mongoid(object)
    return printable if !defined?(Mongoid::Document) || !defined?(ActiveSupport::OrderedHash)

    if printable == :self
      printable = :mongoid_instance if is_mongoid?(object.class)
    elsif printable == :class && is_mongoid?(object)
      printable = :mongoid_document
    end
    printable
  end

  def is_mongoid?(clazz)
    clazz.included_modules.include?(Mongoid::Document)    
  end

  def awesome_mongoid_instance(object)
    hash = ActiveSupport::OrderedHash.new
    object.attributes.sort_by { |key| key }.each do |key, value|
      hash[key.to_sym] = value
    end
    "#{object} #{awesome_hash(hash)}"
  end

  def awesome_mongoid_document(object)
    hash = ActiveSupport::OrderedHash.new
    object.fields.sort_by { |key| key }.each do |key, value|
      hash[key.to_sym] = value.type
    end
    "class #{object} < #{object.superclass} #{awesome_hash(hash)}"
  end
end

AwesomePrint.send(:include, AwesomePrintMongoid)
