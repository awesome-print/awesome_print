# Copyright (c) 2010-2013 Michael Dvorkin
#
# Awesome Print is freely distributable under the terms of MIT license.
# See LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
module AwesomePrint
  module NoBrainer

    # Add NoBrainer class names to the dispatcher pipeline.
    #------------------------------------------------------------------------------
    def cast_with_no_brainer(object, type)
      cast = cast_without_no_brainer(object, type)
      if defined?(::NoBrainer::Document)
        if object.is_a?(Class) && object.ancestors.include?(::NoBrainer::Document)
          cast = :no_brainer_class
        elsif object.is_a?(::NoBrainer::Document)
          cast = :no_brainer_document
        end
      end
      cast
    end

    # Format NoBrainer class object.
    #------------------------------------------------------------------------------
    def awesome_no_brainer_class(object)
      data = Hash[object.fields.map do |field, options|
        [field, (options[:type] || Object).to_s.underscore.to_sym]
      end]
      "class #{object} < #{object.superclass} " << awesome_hash(data)
    end

    # Format NoBrainer Document object.
    #------------------------------------------------------------------------------
    def awesome_no_brainer_document(object)
      data = object.inspectable_attributes
      if object.errors.present?
        data = {:errors => object.errors, :attributes => data}
      end
      "#{object} #{awesome_hash(data)}"
    end
  end
end

AwesomePrint::Plugin.add(AwesomePrint::NoBrainer)
