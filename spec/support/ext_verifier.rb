module ExtVerifier

  def require_dependencies!(dependencies)
    dependencies.each do |dependency|
      begin
        require dependency
      rescue LoadError
      end
    end
  end
  module_function :require_dependencies!

  def has_rails?
    defined?(Rails)
  end
  module_function :has_rails?

  def has_mongoid?
    defined?(Mongoid)
  end
  module_function :has_mongoid?
end

RSpec.configure do |config|
  config.include(ExtVerifier)
  config.extend(ExtVerifier)
end
