# Copyright (c) 2010-2016 Michael Dvorkin and contributors
#
# Awesome Print is freely distributable under the terms of MIT license.
# See LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
module AwesomePrint
  module Mongoid

    def self.included(base)
      base.send :alias_method, :cast_without_mongoid, :cast
      base.send :alias_method, :cast, :cast_with_mongoid
    end

    # Add Mongoid class names to the dispatcher pipeline.
    #------------------------------------------------------------------------------
    def cast_with_mongoid(object, type)
      cast = cast_without_mongoid(object, type)
      if defined?(::Mongoid::Document)
        if Class === object && object < ::Mongoid::Document
          cast = :mongoid_class
        elsif ::Mongoid::Document === object
          cast = :mongoid_document
        elsif (defined?(::BSON) && ::BSON::ObjectId === object) || (defined?(::Moped::BSON) && ::Moped::BSON::ObjectId === object)
          cast = :mongoid_bson_id
        end
      end
      cast
    end

    # Format Mongoid class object.
    #------------------------------------------------------------------------------
    def awesome_mongoid_class(object)
      return object.inspect if !defined?(::ActiveSupport::OrderedHash) || !object.respond_to?(:fields)

      data = object.fields.sort_by { |key| key }.inject(::ActiveSupport::OrderedHash.new) do |hash, c|
        hash[c[1].name.to_sym] = (c[1].type || 'undefined').to_s.underscore.intern
        hash
      end

      name = "class #{awesome_simple(object.to_s, :class)}"
      base = "< #{awesome_simple(object.superclass.to_s, :class)}"

      [name, base, awesome_hash(data)].join(' ')
    end

    # Format Mongoid Document object.
    #------------------------------------------------------------------------------
    def awesome_mongoid_document(object)
      return object.inspect if !defined?(::ActiveSupport::OrderedHash)

      data = (object.attributes || {}).sort_by { |key| key }.inject(::ActiveSupport::OrderedHash.new) do |hash, c|
        hash[c[0].to_sym] = c[1]
        hash
      end
      data = { errors: object.errors, attributes: data } if !object.errors.empty?
      "#{object} #{awesome_hash(data)}"
    end

    # Format BSON::ObjectId
    #------------------------------------------------------------------------------
    def awesome_mongoid_bson_id(object)
      object.inspect
    end
  end
end

AwesomePrint::Formatter.send(:include, AwesomePrint::Mongoid)
