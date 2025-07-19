# appraise 'rails-4.2' do
#   gem 'rails', '~> 4.2.0'
#
#   # The last version that doesn't need Ruby 2.0 and works with version 4.2 of
#   # Rails. This addresses a build problem with Travis for version 1.9.3 of Ruby
#   gem 'mime-types', '2.6.2', :platforms => :ruby_19
# end

if RUBY_VERSION < '3.0.0'
  appraise 'rails-5.0' do
    gem 'rails', '>= 5.0.0', '< 5.1'
    gem 'sqlite3', '~> 1.3.6'
  end

  appraise 'rails-5.1' do
    gem 'rails', '>= 5.1.0', '< 5.2'
    gem 'sqlite3', '~> 1.3.0'
  end

  appraise 'rails-5.2' do
    gem 'rails', '>= 5.2.0', '< 5.3'
    gem 'sqlite3', '~> 1.3.0'
  end
end

appraise 'rails-6.0' do
  gem 'rails', '>= 6.0.0', '< 6.1'
  gem 'sqlite3', '~> 1.4'
  gem 'bigdecimal' # for ruby 3.4+
  gem 'mutex_m' # for ruby 3.4+
  gem 'concurrent-ruby', '1.3.4'
end

appraise 'rails-6.1' do
  gem 'rails', '>= 6.1.0', '< 6.2'
  gem 'sqlite3', '~> 1.4'
  gem 'bigdecimal' # for ruby 3.4+
  gem 'mutex_m' # for ruby 3.4+
  gem 'concurrent-ruby', '1.3.4'
end

if RUBY_VERSION > '2.7.0'
  appraise 'rails-7.0' do
    gem 'rails', '>= 7.0.0', '< 7.1'
    gem 'sqlite3', '~> 1.4'
    gem 'bigdecimal' # for ruby 3.4+
    gem 'mutex_m' # for ruby 3.4+
    gem 'concurrent-ruby', '1.3.4'
  end

  appraise 'rails-7.1' do
    gem 'rails', '>= 7.1.0', '< 7.2'
    gem 'sqlite3'
    gem 'bigdecimal' # for ruby 3.4+
    gem 'mutex_m' # for ruby 3.4+
  end
end

if RUBY_VERSION > '3.2.0'
  appraise 'rails-7.2' do
    gem 'rails', '>= 7.2.0', '< 8.0'
    gem 'sqlite3'
    gem 'bigdecimal' # for ruby 3.4+
    gem 'mutex_m' # for ruby 3.4+
  end

  appraise 'rails-8.0' do
    gem 'rails', '>= 8.0.0', '< 8.1'
    gem 'sqlite3'
    gem 'bigdecimal' # for ruby 3.4+
    gem 'mutex_m' # for ruby 3.4+
  end
end

if RUBY_VERSION < '3.0.0'
  appraise 'mongoid-5.0' do
    gem 'mongoid', '~> 5.0.0'
    gem 'bigdecimal', '~> 1.3.5'
  end

  appraise 'mongoid-6.0' do
    gem 'mongoid', '~> 6.0.0'
  end
end

appraise 'mongoid-7.0' do
  gem 'mongoid', '~> 7.0.0'
  gem 'bigdecimal' # for ruby 3.4+
  gem 'mutex_m' # for ruby 3.4+
  gem 'concurrent-ruby', '1.3.4'
end

appraise 'mongoid-7.1' do
  gem 'mongoid', '~> 7.1.0'
  gem 'bigdecimal' # for ruby 3.4+
  gem 'mutex_m' # for ruby 3.4+
  gem 'concurrent-ruby', '1.3.4'
end

# appraise 'mongo_mapper' do
#   gem 'mongo_mapper'
# end
#
# appraise 'ripple' do
#   gem 'tzinfo'
#   gem 'ripple'
# end
#
# appraise 'nobrainer' do
#   gem 'nobrainer'
#
#   # When activesupport 5 was released, it required ruby 2.2.2 as a minimum.
#   # Locking this down to 4.2.6 allows our Ruby 1.9 tests to keep working.
#   gem 'activesupport', '4.2.6', :platforms => :ruby_19
# end
