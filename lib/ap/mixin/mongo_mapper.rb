# Copyright (c) 2010-2011 Michael Dvorkin
#
# Awesome Print is freely distributable under the terms of MIT license.
# See LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
module AwesomePrintMongoMapper

  def self.included(base)
    base.send :alias_method, :printable_without_mongo_mapper, :printable
    base.send :alias_method, :printable, :printable_with_mongo_mapper
  end

  # Add MongoMapper class names to the dispatcher pipeline.
  #------------------------------------------------------------------------------
  def printable_with_mongo_mapper(object)
    printable = printable_without_mongo_mapper(object)
    return printable if !defined?(MongoMapper::Document)

    if printable == :self
      if object.is_a?(MongoMapper::Document) || object.is_a?(MongoMapper::EmbeddedDocument)
        printable = :mongo_mapper_instance
      end
    elsif printable == :class && (object.ancestors & [MongoMapper::Document, MongoMapper::EmbeddedDocument]).size > 0
      printable = :mongo_mapper_class
    end
    printable
  end

  # Format MongoMapper instance object.
  #------------------------------------------------------------------------------
  def awesome_mongo_mapper_instance(object)
    return object.inspect if !defined?(ActiveSupport::OrderedHash)

    data = object.keys.keys.sort_by{|k| k}.inject(ActiveSupport::OrderedHash.new) do |hash, name|
      hash[name] = object[name]
      hash
    end
    "#{object} " + awesome_hash(data)
  end

  # Format MongoMapper class object.
  #------------------------------------------------------------------------------
  def awesome_mongo_mapper_class(object)
    return object.inspect if !defined?(ActiveSupport::OrderedHash) || !object.respond_to?(:keys)

    data = object.keys.sort_by{|k| k}.inject(ActiveSupport::OrderedHash.new) do |hash, c|
      hash[c.first] = (c.last.type || "undefined").to_s.underscore.intern
      hash
    end
    "class #{object} < #{object.superclass} " << awesome_hash(data)
  end
end

AwesomePrint.send(:include, AwesomePrintMongoMapper)
