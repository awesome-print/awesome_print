
module AwesomePrint
  module Reflection
    extend self

    CLASS_METHOD = Class.instance_method(:class)
    private_constant :CLASS_METHOD

    #: (BasicObject) -> Class[top]
    def class_of(object)
      bind_call(CLASS_METHOD, object)
    end

    RESPOND_TO_METHOD = Kernel.instance_method(:respond_to?)
    private_constant :RESPOND_TO_METHOD

    #: (BasicObject, Symbol) -> Boolean
    def obj_respond_to?(object, method_name)
      bind_call(RESPOND_TO_METHOD, object, method_name)
    end

    METHOD_METHOD = Kernel.instance_method(:method)
    private_constant :METHOD_METHOD

    #: (Module, Symbol) -> Method
    def method_of(constant, method)
      bind_call(METHOD_METHOD, constant, method)
    end

    private

    if UnboundMethod.method_defined?(:bind_call)
      def bind_call(unbound_method, receiver, *args)
        unbound_method.bind_call(receiver, *args)
      end
    else # Backwards compatibility for Ruby <= 2.7
      def bind_call(unbound_method, receiver, *args)
        unbound_method.bind(receiver).call(*args)
      end
    end
  end
end
