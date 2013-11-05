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
      #
      # Make sure calling AwesomePrint::Plugin.register twice for the same
      # plugin doesn't do any harm.
      #
      return nil if @list.include?(mod)
      #
      # The plugin *must* implement :cast(object, type) method.
      #
      unless mod.instance_methods.include?(:cast)
        raise RuntimeError, "#{mod} plugin should define cast(object, type) instance method"
      end
      #
      # Create the hook name from the plugin's module name, for example:
      # ActiveRecord => "active_record". Once we have the hook name rename
      # generic :cast method to unique :cast_<hook_name>.
      #
      hook = mod.name.gsub(/^.*::/, "").gsub(/(.)([A-Z])/, '\1_\2').downcase
      mod.send(:alias_method, :"cast_#{hook}", :cast)
      mod.send(:remove_method, :cast)
      #
      # Add plugin's instance methods to AwesomePrint::Formatter, then hook
      # formatter's :cast method.
      #
      formatter = AwesomePrint::Formatter
      formatter.send(:include, mod)
      #
      # The method chaining is done as follows:
      #
      # 1. Original :cast method becomes :cast_without_<hook_name>.
      # 2. New :cast_with_<hook_name> method gets created dynamically. It calls
      #    plugin's :cast (renamed :cast_<hook_name> above) and if the return
      #    value is nil (i.e. no cast) it calls the original :cast from step 1.
      # 3. Calling :cast now invokes :cast_with_<hook_name> from step 2.
      #
      chain_methods(formatter, hook) do
        formatter.send(:define_method, :"cast_with_#{hook}") do |object, type|
          send(:"cast_#{hook}", object, type) || send(:"cast_without_#{hook}", object, type)
        end
      end
      @list << mod
    end

    private

    def chain_methods(formatter, hook)
      formatter.send(:alias_method, :"cast_without_#{hook}", :cast)
      yield # <-- Define :"cast_with_#{hook}".
      formatter.send(:alias_method, :cast, :"cast_with_#{hook}")
    end
  end
end
