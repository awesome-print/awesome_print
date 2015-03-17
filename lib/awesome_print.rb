#
# AwesomePrint might be loaded implicitly through ~/.irbrc or ~/.pryrc
# so do nothing for subsequent requires.
#
unless defined?(AwesomePrint::Inspector)
  %w(array string method object class kernel).each do |file|
    require File.dirname(__FILE__) + "/awesome_print/core_ext/#{file}"
  end

  require File.dirname(__FILE__) + "/awesome_print/support"
  require File.dirname(__FILE__) + "/awesome_print/configuration"
  require File.dirname(__FILE__) + "/awesome_print/inspector"
  require File.dirname(__FILE__) + "/awesome_print/formatter"
  require File.dirname(__FILE__) + "/awesome_print/version"
  require File.dirname(__FILE__) + "/awesome_print/core_ext/logger" if defined?(Logger)

  #
  # Load remaining extensions.
  #
  if defined?(ActiveSupport)
    ActiveSupport.on_load(:action_view) do
      require File.dirname(__FILE__) + "/awesome_print/ext/action_view"
    end
  end
  require File.dirname(__FILE__) + "/awesome_print/ext/mongo_mapper"   if defined?(MongoMapper)
  require File.dirname(__FILE__) + "/awesome_print/ext/nokogiri"       if defined?(Nokogiri)
  require File.dirname(__FILE__) + "/awesome_print/ext/nobrainer"      if defined?(NoBrainer)
  require File.dirname(__FILE__) + "/awesome_print/ext/ripple"         if defined?(Ripple)
  require File.dirname(__FILE__) + "/awesome_print/ext/sequel"         if defined?(Sequel)
  require File.dirname(__FILE__) + "/awesome_print/ext/ostruct"        if defined?(OpenStruct)
end
