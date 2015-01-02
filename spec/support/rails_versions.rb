module RailsVersions
  def rails_version
    Gem::Version.new(Rails::VERSION::STRING)
  end

  def rails_4_2?
    Gem::Requirement.new('~> 4.2.0').satisfied_by?(rails_version)
  end
  alias_method :activerecord_4_2?, :rails_4_2?

  def rails_4_1?
    Gem::Requirement.new('~> 4.1.0').satisfied_by?(rails_version)
  end
  alias_method :activerecord_4_1?, :rails_4_1?

  def rails_4_0?
    Gem::Requirement.new('~> 4.0.0').satisfied_by?(rails_version)
  end
  alias_method :activerecord_4_0?, :rails_4_0?

  def rails_3_2?
    Gem::Requirement.new('~> 3.2.0').satisfied_by?(rails_version)
  end
  alias_method :activerecord_3_2?, :rails_3_2?
end

RSpec.configure do |config|
  config.include(RailsVersions)
  config.extend(RailsVersions)
end
