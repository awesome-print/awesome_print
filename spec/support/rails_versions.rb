module RailsVersions
  def rails_version
    Gem::Version.new(::Rails::VERSION::STRING)
  end

  def rails_5_2?
    Gem::Requirement.new('~> 5.2.0').satisfied_by?(rails_version)
  end
  alias_method :activerecord_5_2?, :rails_5_2?

  def rails_5_1?
    Gem::Requirement.new('~> 5.1.0').satisfied_by?(rails_version)
  end
  alias_method :activerecord_5_1?, :rails_5_1?

  def rails_5_0?
    Gem::Requirement.new('~> 5.0.0').satisfied_by?(rails_version)
  end
  alias_method :activerecord_5_0?, :rails_5_0?
end

RSpec.configure do |config|
  config.include(RailsVersions)
  config.extend(RailsVersions)
end
