#
# Method#name was intorduced in Ruby 1.8.7 so we define it here as necessary.
#
unless nil.method(:class).respond_to?(:name)
  class Method
    def name
      inspect.split(/[#.>]/)[-1]
    end
  end

  class UnboundMethod
    def name
      inspect.split(/[#.>]/)[-1]
    end
  end
end
