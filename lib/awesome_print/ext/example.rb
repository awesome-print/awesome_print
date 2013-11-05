module AwesomePrint
  module Radix

    def cast(object, type)
      # puts "example#cast(#{object.inspect}, #{type.inspect})"
      :radix if object.is_a?(Fixnum)
    end

    private

    def awesome_radix(object)
      # puts "example#awesome_radix(#{object.inspect})"
      "#{object} (dec) 0#{object.to_s(8)} (oct) 0x#{object.to_s(16).upcase} (hex)"
    end
  end
end

AwesomePrint::Plugin.register(AwesomePrint::Radix)
