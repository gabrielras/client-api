# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '~> 6.1.4', '>= 6.1.4.1'
# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1'
# Use Puma as the app server
gem 'puma', '~> 5.0'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'
gem 'dotenv-rails', '2.7.6'
gem 'enumerate_it', '3.2.1'
gem 'grape', github: 'neocoin/grape', branch: 'master'
gem 'httparty', '0.20.0'
gem 'sentry-rails', '4.6.4'
gem 'sentry-ruby', '4.6.4'
gem 'service_actor', '3.1.2'
gem 'sidekiq', '~> 6.2.1'
gem 'sidekiq-status', '2.0.2'
gem 'sidekiq-throttled', '0.13.0'
gem 'state_machines-activerecord', '0.8.0'
gem 'statesman', '8.0.3'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.4', require: false

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem 'rack-cors'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails', '6.2.0'
  gem 'faker', '2.18.0'
  gem 'rspec-rails', '5.0.1'
end

group :development do
  gem 'annotate'
  gem 'brakeman', '5.1.1'
  gem 'listen', '~> 3.3'
  gem 'rack-mini-profiler', '2.3.3'
  gem 'web-console', '4.1.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '3.36.0'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'rails-controller-testing', '1.0.5'
  gem 'shoulda-matchers', '5.0.0'
  gem 'webdrivers'
  gem 'webmock', '3.13.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
