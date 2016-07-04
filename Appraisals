appraise 'rails-3.2' do
  gem 'rails', '~> 3.2.0'
end

appraise 'rails-4.0' do
  gem 'rails', '~> 4.0.0'
  gem 'json',  '~> 1.8', :platforms => :ruby_19 # Json 2.0 requires Ruby >= 2.0

  # The last version that doesn't need Ruby 2.0 and works with version 4.0 of
  # Rails. This addresses a build problem with Travis for version 1.9.3 of Ruby
  gem 'mime-types', '2.6.2', :platforms => :ruby_19
end

appraise 'rails-4.1' do
  gem 'rails', '~> 4.1.0'

  # The last version that doesn't need Ruby 2.0 and works with version 4.1 of
  # Rails. This addresses a build problem with Travis for version 1.9.3 of Ruby
  gem 'mime-types', '2.6.2', :platforms => :ruby_19
end

appraise 'rails-4.2' do
  gem 'rails', '~> 4.2.0'

  # The last version that doesn't need Ruby 2.0 and works with version 4.2 of
  # Rails. This addresses a build problem with Travis for version 1.9.3 of Ruby
  gem 'mime-types', '2.6.2', :platforms => :ruby_19
end

appraise 'rails-5.0' do
  # Only works with Ruby >= 2.2
  gem 'rails', '>= 5.0.0.racecar1', '< 5.1'
end

appraise 'mongoid-3.0' do
  gem 'mongoid', '~> 3.0.0'
end

appraise 'mongoid-3.1' do
  gem 'mongoid', '~> 3.1.0'
  gem 'json',  '~> 1.8', :platforms => :ruby_19 # Json 2.0 requires Ruby >= 2.0
end

appraise 'mongoid-4.0' do
  gem 'mongoid', '~> 4.0.0'
end

appraise 'mongo_mapper' do
  gem 'mongo_mapper'
end

appraise 'ripple' do
  gem 'tzinfo'
  gem 'ripple'
end

appraise 'nobrainer' do
  gem 'nobrainer'

  # When activesupport 5 was released, it required ruby 2.2.2 as a minimum.
  # Locking this down to 4.2.6 allows our Ruby 1.9 tests to keep working.
  gem 'activesupport', '4.2.6', :platforms => :ruby_19
end
