module AwesomePrint
  class Indentator

    attr_reader :shift_width, :indentation

    def initialize(indentation, current = nil)
      @indentation = current ? current : indentation
      @shift_width = indentation.freeze
    end

    def indent
      @indentation += shift_width
      yield
    ensure
      @indentation -= shift_width
    end
  end
end
