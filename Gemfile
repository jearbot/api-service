source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.3'
gem 'rails', '~> 7.0', '>= 7.0.4.3'

# Use Active Model Serializers for generating JSON APIs
gem 'active_model_serializers', '~> 0.10.13', require: true
# Use pagination for APIs
gem 'api-pagination', '~> 5.0'
# Generate random string ids
gem 'external_id', git: 'https://github.com/dimroc/external_id'
# Generate fake data
gem 'faker', '~> 3.1', '>= 3.1.1'
# A library for setting up Ruby objects as test data.
gem 'factory_bot_rails', '~> 6.2', require: true
# Use friendly URLs with slugs
gem 'friendly_id', '~> 5.5'
# Use Google Maps Directions API
gem 'google_api_directions', '~> 0.0.4'
# Use HTTParty for making HTTP requests
gem 'httparty', '~> 0.21.0'
# Build JSON APIs with ease
gem 'jbuilder', '~> 2.7'
# Use paranoia for soft deletion of records
gem 'paranoia', '~> 2.6', '>= 2.6.1'
# Use Postgres as the database for Active Record
gem 'pg', '~> 1.4', '>= 1.4.6'
# Use Puma as the app server
gem 'puma', '~> 5.0'
# Use Rubocop for code linting
gem 'rubocop', '~> 1.48', '>= 1.48.1'
# Use Sass for stylesheets
gem 'sass-rails', '>= 6'
# Generate secure random numbers and strings
gem 'securerandom', '~> 0.2.2'
# Use Turbolinks for faster navigation
gem 'turbolinks', '~> 5'
# Use Webpacker for transpiling app-like JavaScript
gem 'webpacker', '~> 5.4', '>= 5.4.4'
# Use Will Paginate for pagination
gem 'will_paginate', '~> 3.3', '>= 3.3.1'
# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.4', require: false

group :development, :test do
  # Test framework for behavior-driven development (BDD).
  gem 'rspec', '~> 3.12'
  # Integration between RSpec and Rails.
  gem 'rspec-rails', '~> 6.0.0'
  # A powerful alternative to the standard IRB shell for Ruby.
  gem 'pry-rails', '~> 0.3.9'
  # A plugin for the Pry REPL that allows navigation around a codebase.
  gem 'pry-nav', '~> 1.0'
  # Should matchers for RSPEC tests
  gem 'shoulda-matchers', '~> 5.3'
end


group :development do
  # Adds a comment summarizing the current schema to the top of your models, factories, etc. Useful for keeping track of changes to your schema over time.
  gem 'annotate', '~> 3.2'
  # Watches your file system for changes and triggers actions (like restarting your server) when files are modified. Used by some development tools to keep your environment up-to-date.
  gem 'listen', '~> 3.3'
  # Displays performance information such as SQL time and flame graphs for each request in your browser.
  # Can be configured to work on production as well see: https://github.com/MiniProfiler/rack-mini-profiler/blob/master/README.md
  gem 'rack-mini-profiler', '~> 2.0'
  # Speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 4.1.0'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 3.26'
  # Library that provides a way to control web browsers through code
  gem 'selenium-webdriver', '>= 4.0.0.rc1'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]