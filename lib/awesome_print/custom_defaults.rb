module AwesomePrint
  class << self
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

    def diet_rb
      IRB.formatter = Class.new(IRB::Formatter) do
        def inspect_object(object)
          object.ai
        end
      end.new
    end

    def usual_rb
      IRB::Irb.class_eval do
        def output_value
          ap @context.last_value
        rescue NoMethodError        
          puts "(Object doesn't support #ai)"
        end
      end
    end

    def irb!
      return unless defined?(IRB)

      IRB.version.include?("DietRB") ? diet_rb : usual_rb
    end

    def pry!
      Pry.print = proc { |output, value| output.puts value.ai } if defined?(Pry)
    end
  end
end
