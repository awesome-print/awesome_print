module RailsVersions
  def rails_version
    Gem::Version.new(Rails::VERSION::STRING)
  end

  def rails_8_0?
    Gem::Requirement.new('~> 8.0.0').satisfied_by?(rails_version)
  end
  alias_method :activerecord_8_0?, :rails_8_0?

  def rails_7_2?
    Gem::Requirement.new('~> 7.2.0').satisfied_by?(rails_version)
  end
  alias_method :activerecord_7_2?, :rails_7_2?

  def rails_7_1?
    Gem::Requirement.new('~> 7.1.0').satisfied_by?(rails_version)
  end
  alias_method :activerecord_7_1?, :rails_7_1?

  def rails_7_0?
    Gem::Requirement.new('~> 7.0.0').satisfied_by?(rails_version)
  end
  alias_method :activerecord_7_0?, :rails_7_0?

  def rails_6_1?
    Gem::Requirement.new('~> 6.1.0').satisfied_by?(rails_version)
  end
  alias_method :activerecord_6_1?, :rails_6_1?

  def rails_6_0?
    Gem::Requirement.new('~> 6.0.0').satisfied_by?(rails_version)
  end
  alias_method :activerecord_6_0?, :rails_6_0?

  def rails_5_2?
    Gem::Requirement.new('~> 5.2.0').satisfied_by?(rails_version)
  end
  alias_method :activerecord_5_2?, :rails_5_2?

  def rails_5_1?
    Gem::Requirement.new('~> 5.1.0').satisfied_by?(rails_version)
  end
  alias_method :activerecord_5_1?, :rails_5_1?

  def rails_5_0?
    Gem::Requirement.new('~> 5.0.0.racecar1').satisfied_by?(rails_version)
  end
  alias_method :activerecord_5_0?, :rails_5_0?

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
