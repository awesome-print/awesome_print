# Copyright (c) 2010-2016 Michael Dvorkin and contributors
#
# Awesome Print is freely distributable under the terms of MIT license.
# See LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
module AwesomePrint
  module Sequel

    def self.included(base)
      base.send :alias_method, :cast_without_sequel, :cast
      base.send :alias_method, :cast, :cast_with_sequel
    end

    # Add Sequel class names to the dispatcher pipeline.
    #------------------------------------------------------------------------------
    def cast_with_sequel(object, type)
      cast = cast_without_sequel(object, type)
      if defined?(::Sequel::Model) && object.is_a?(::Sequel::Model)
        cast = :sequel_document
      elsif defined?(::Sequel::Model) && object.is_a?(Class) && object.ancestors.include?(::Sequel::Model)
        cast = :sequel_model_class
      elsif defined?(::Sequel::Mysql2::Dataset) && object.class.ancestors.include?(::Sequel::Mysql2::Dataset)
        cast = :sequel_dataset
      end
      cast
    end

    # Format Sequel Document object.
    #------------------------------------------------------------------------------
    def awesome_sequel_document(object)
      data = object.values.sort_by { |key| key.to_s }.inject({}) do |hash, c|
        hash[c[0].to_sym] = c[1]
        hash
      end
      data = { errors: object.errors, values: data } if !object.errors.empty?
      "#{object} #{awesome_hash(data)}"
    end

    # Format Sequel Dataset object.
    #------------------------------------------------------------------------------
    def awesome_sequel_dataset(dataset)
      [awesome_array(dataset.to_a), awesome_print(dataset.sql)].join("\n")
    end

    # Format Sequel Model class.
    #------------------------------------------------------------------------------
    def awesome_sequel_model_class(object)
      data = object.db_schema.inject({}) { |h, (prop, defn)| h.merge(prop => defn[:db_type]) }
      name = "class #{awesome_simple(object.to_s, :class)}"
      base = "< #{awesome_simple(object.superclass.to_s, :class)}"

      [name, base, awesome_hash(data)].join(' ')
    end
  end

end

AwesomePrint::Formatter.send(:include, AwesomePrint::Sequel)
