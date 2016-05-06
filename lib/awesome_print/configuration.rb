module AwesomePrint

  class << self # Class accessors for custom defaults.
    attr_accessor :defaults, :force_colors

    # Class accessor to force colorized output (ex. forked subprocess where TERM
    # might be dumb).
    #------------------------------------------------------------------------------
    def force_colors!(value = true)
      @force_colors = value
    end

    def console?
      !!(defined?(IRB) || defined?(Pry))
    end

    def rails_console?
      console? && !!(defined?(Rails::Console) || ENV["RAILS_ENV"])
    end

    def irb!
      return unless defined?(IRB)
      unless IRB.version.include?("DietRB")
        IRB::Irb.class_eval do
          def output_value
            ap @context.last_value
          end
        end
      else # MacRuby
        IRB.formatter = Class.new(IRB::Formatter) do
          def inspect_object(object)
            object.ai
          end
        end.new
      end
    end

    def pry!
      if defined?(Pry)
        Pry.print = proc { |output, value| output.puts value.ai }
      end
    end
  end
end
