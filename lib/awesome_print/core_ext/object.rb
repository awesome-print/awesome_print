class Object #:nodoc:
  #
  # Intercept methods below to inject @__awesome_print__ instance variable
  # so we know it is the *methods* array when formatting an array.
  #
  # Remaining instance '_methods' are handled in core_ext/class.rb.
  #
  %w(methods private_methods protected_methods public_methods singleton_methods).each do |name|
    original_method = instance_method(name)

    define_method name do |*args|
      methods = original_method.bind(self).call(*args)
      methods.instance_variable_set('@__awesome_methods__', self)
      methods
    end
  end
end
