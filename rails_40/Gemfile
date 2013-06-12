source 'https://rubygems.org'

# Heroku uses the ruby version to configure your application's runtime.
ruby '2.0.0'

gem 'unicorn'

gem 'rails', '~> 4.0.0.rc2'
gem 'pg'

gem 'slim-rails'
gem 'less-rails'
gem 'less-rails-bootstrap'
gem 'jquery-rails'
gem 'coffee-rails'
gem 'turbolinks'
gem 'simple_form', '~> 3.0.0.rc'
gem 'uglifier'

gem 'awesome_print'

# Heroku suggests that these gems aren't necessary, but they're required to compile less assets on deploy.
gem 'therubyracer', platforms: :ruby
#gem 'libv8'#, '~> 3.11.8'

group :test, :development do
  gem 'rspec-rails'
  gem 'capybara'
  #gem 'capybara-email'
  gem 'factory_girl_rails'
  gem 'database_cleaner'
  #gem 'jasminerice'
  #gem 'timecop'
  gem 'simplecov'
  #gem 'cane'
  #gem 'morecane'
  #gem 'quiet_assets'
end

group :development do
  gem 'foreman'
  #gem 'launchy'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'guard'
  gem 'guard-rspec'
  #gem 'guard-jasmine'
  #gem 'guard-livereload'
  gem 'rb-fsevent'
  gem 'growl'
end
