source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.5'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.1'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 3.11'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.5'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem 'rack-cors'
gem 'pry-rails'

gem 'redis-rails'
gem 'jwt'
gem 'sorcery', '~> 0.12.0'
gem 'device_detector'
gem "carrierwave-base64"
gem "carrierwave"
gem 'mini_magick'
gem 'rmagick', '2.16.0'
gem 'chewy'
gem "roo", "~> 2.8.0"

gem 'mina', require: false
gem 'foreman', require: false

gem 'rswag-api'
gem 'rswag-ui'

gem 'twilio-ruby', '~> 5.38.0'

group :development, :test do
  gem 'rspec-rails', '~> 3.7'
  gem 'rspec-json_expectations'
  gem 'shoulda-matchers', '~> 3.1'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'rswag-specs'
  gem 'figaro'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end
