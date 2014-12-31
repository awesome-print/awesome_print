module MongoidVersions
  def mongoid_version
    Gem::Version.new(Mongoid::VERSION)
  end

  def mongoid_4_0?
    Gem::Requirement.new('~> 4.0.0').satisfied_by?(mongoid_version)
  end

  def mongoid_3_0?
    Gem::Requirement.new('~> 3.0.0').satisfied_by?(mongoid_version)
  end

  def mongoid_3_1?
    Gem::Requirement.new('~> 3.1.0').satisfied_by?(mongoid_version)
  end
end

RSpec.configure do |config|
  config.include(MongoidVersions)
  config.extend(MongoidVersions)
end
