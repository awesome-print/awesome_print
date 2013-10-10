# Copyright (c) 2010-2013 Michael Dvorkin
#
# Awesome Print is freely distributable under the terms of MIT license.
# See LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
module AwesomePrint
  module Plugin
    extend self

    @list = []; attr_reader :list

    def add(mod)
      formatter = AwesomePrint::Formatter
      formatter.send(:include, mod)

      hook = mod.name.gsub(/^.*::/, "").gsub(/(.)([A-Z])/, '\1_\2').downcase
      formatter.send(:alias_method, :"cast_without_#{hook}", :cast)
      formatter.send(:alias_method, :cast, :"cast_with_#{hook}")
    end

    def register(mod)
      puts "mod.instance_methods: #{mod.instance_methods}"
      unless mod.instance_methods.include?(:cast)
        raise RuntimeError, "#{mod} plugin should define cast(object, type) instance method"
      end

      formatter = AwesomePrint::Formatter
      hook = mod.name.gsub(/^.*::/, "").gsub(/(.)([A-Z])/, '\1_\2').downcase

      mod.send(:alias_method, :"cast_#{hook}", :cast)
      mod.send(:remove_method, :cast)

      @list << mod
      formatter.send(:include, mod)

      puts "defining cast_with_#{hook}..."

      # formatter.send(:alias_method, :"cast_without_#{hook}", :cast)
      chain_methods(formatter, hook) do
        formatter.send(:define_method, :"cast_with_#{hook}") do |object, type|
          puts "cast_with_#{hook}(#{object.inspect}, #{type.inspect})"
          cast = send(:"cast_#{hook}", object, type) || send(:"cast_without_#{hook}", object, type)
        end
      end
      # formatter.send(:alias_method, :cast, :"cast_with_#{hook}")
    end

    private

    def chain_methods(formatter, hook)
      formatter.send(:alias_method, :"cast_without_#{hook}", :cast)
      yield
      formatter.send(:alias_method, :cast, :"cast_with_#{hook}")
    end
  end
end
