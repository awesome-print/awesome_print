module ExtVerifier

  def has_rails?
    defined?(::Rails)
  end
  module_function :has_rails?

  def has_mongoid?
    defined?(::Mongoid)
  end
  module_function :has_mongoid?
end

RSpec.configure do |config|
  config.include(ExtVerifier)
  config.extend(ExtVerifier)
end
