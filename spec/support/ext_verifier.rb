module ExtVerifier

  def has_rails?
    defined?(::Rails)
  end
  module_function :has_rails?
end

RSpec.configure do |config|
  config.include(ExtVerifier)
  config.extend(ExtVerifier)
end
