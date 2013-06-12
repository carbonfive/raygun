source 'https://rubygems.org'

# Heroku uses the ruby version to configure your application's runtime.
ruby '2.0.0'

gem 'unicorn'
gem 'rails', '~> 4.0.0.rc2'
gem 'slim-rails'
gem 'jquery-rails'
gem 'turbolinks'
gem 'pg'
gem 'awesome_print'

group :assets do
  gem 'less-rails'
  gem 'less-rails-bootstrap'
  gem 'coffee-rails'
  gem 'uglifier'

  # Heroku suggests that these gems aren't necessary, but they're required to compile less assets on deploy.
  #gem 'therubyracer', platforms: :ruby
  #gem 'libv8'#, '~> 3.11.8'
end

group :test, :development do
  gem 'rspec-rails'
  gem 'capybara'
  #gem 'capybara-email'
  gem 'factory_girl_rails'
  #gem 'jasminerice'
  #gem 'timecop'
  #gem 'simplecov'
  #gem 'cane'
  #gem 'morecane'
  #gem 'quiet_assets'
end

group :development do
  gem 'foreman'
  #gem 'launchy'
  gem 'guard'
  gem 'guard-rspec'
  #gem 'guard-jasmine'
  #gem 'guard-livereload'
  gem 'rb-fsevent'
  gem 'growl'
end
