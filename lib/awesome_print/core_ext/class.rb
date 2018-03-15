# Copyright (c) 2010-2016 Michael Dvorkin and contributors
#
# Awesome Print is freely distributable under the terms of MIT license.
# See LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
class Class #:nodoc:
  #
  # Intercept methods below to inject @__awesome_print__ instance variable
  # so we know it is the *methods* array when formatting an array.
  #
  # Remaining public/private etc. '_methods' are handled in core_ext/object.rb.
  #
  %w(instance_methods private_instance_methods protected_instance_methods public_instance_methods).each do |name|
    original_method = instance_method(name)

    define_method name do |*args|
      methods = original_method.bind(self).call(*args)
      methods.instance_variable_set(:@__awesome_methods__, self)
      methods.extend(AwesomeMethodArray)
      methods
    end
  end


  # Turn class name into symbol, ex: Hello::World => :hello_world. Classes
  # that inherit from Array, Hash, File, Dir, and Struct are treated as the
  # base class.
  def awesome_print_type
    @awesome_print_type ||= to_s.gsub(/:+/, '_').downcase.to_sym
  end
end


class Array
  def self.awesome_print_type
    :array
  end
end


class Hash
  def self.awesome_print_type
    :hash
  end
end


class File
  def self.awesome_print_type
    :file
  end
end


class Dir
  def self.awesome_print_type
    :dir
  end
end


class Struct
  def self.awesome_print_type
    :struct
  end
end

