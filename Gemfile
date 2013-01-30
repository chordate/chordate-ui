source 'https://rubygems.org'

gem 'rails'
gem 'puma'
gem 'pg'
gem 'activerecord-postgres-hstore'
gem 'activerecord-postgres-array'
gem 'redis'
gem 'jquery-rails'
gem 'i18n-js', :git => 'https://github.com/fnando/i18n-js'
gem 'stripe'
gem 'capistrano'
gem 'connection_pool'
gem 'tap-if'
gem 'typhoeus', :git => 'https://github.com/typhoeus/typhoeus'

# gem 'chordate-ruby', :path => '~/git/chordate-ruby'

group :development, :test do
  gem 'rspec'
  gem 'rspec-rails'
  gem 'jasmine', :git => 'https://github.com/pivotal/jasmine-gem'
end

group :test do
  gem 'mock_redis'
  gem 'capybara', '~> 1.1.0'
  gem 'poltergeist'
  gem 'connection_pool'
  gem 'webmock'
  gem 'timecop'
  gem 'fuubar'
  gem 'factory_girl_rails'
  gem 'shoulda-matchers'
end

group :assets do
  gem 'handlebars_assets', :git => 'https://github.com/leshill/handlebars_assets'
  gem 'uglifier'
end
