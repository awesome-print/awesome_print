module ActiveRecordVersions
  def activerecord_version
    Gem::Version.new(ActiveRecord::VERSION::STRING)
  end

  def activerecord_4_2?
    Gem::Requirement.new('~> 4.2.0').satisfied_by?(activerecord_version)
  end

  def activerecord_4_1?
    Gem::Requirement.new('~> 4.1.0').satisfied_by?(activerecord_version)
  end

  def activerecord_4_0?
    Gem::Requirement.new('~> 4.0.0').satisfied_by?(activerecord_version)
  end

  def activerecord_3_2?
    Gem::Requirement.new('~> 3.2.0').satisfied_by?(activerecord_version)
  end
end

RSpec.configure do |config|
  config.include(ActiveRecordVersions)
  config.extend(ActiveRecordVersions)
end
