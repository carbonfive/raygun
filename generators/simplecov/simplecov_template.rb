insert_into_file 'spec/spec_helper.rb', 
  "require File.expand_path('../support/simplecov', __FILE__)\n", 
  after: "ENV[\"RAILS_ENV\"] ||= \'test\'\n"

gem_group :development, :test do
  gem 'simplecov'
end

copy_file 'simplecov/tasks/coverage.rake', 'lib/tasks/coverage.rake'
copy_file 'simplecov/spec/support/simplecov.rb', 'spec/support/simplecov.rb'