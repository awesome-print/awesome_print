module Kernel

  def ai(options = {})
    ap = AwesomePrint::Inspector.new(options)
    awesome = ap.awesome self
    if options[:html]
      awesome = "<pre>#{awesome}</pre>"
      awesome = awesome.html_safe if defined? ActiveSupport
    end
    awesome
  end
  alias :awesome_inspect :ai

  def ap(object, options = {})
    puts object.ai(options)
    object unless AwesomePrint.console?
  end
  alias :awesome_print :ap

  module_function :ap
end
