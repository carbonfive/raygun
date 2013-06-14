# Coverage must be enabled before the application is loaded.
if ENV['COVERAGE']
  require 'simplecov'

  # Writes the coverage stat to a file to be used by Cane.
  class SimpleCov::Formatter::QualityFormatter
    def format(result)
      SimpleCov::Formatter::HTMLFormatter.new.format(result)
      File.open('coverage/covered_percent', 'w') do |f|
        f.puts result.source_files.covered_percent.to_f
      end
    end
  end
  SimpleCov.formatter = SimpleCov::Formatter::QualityFormatter

  SimpleCov.start do
    add_filter '/spec/'
    add_filter '/config/'
    add_filter '/vendor/'
    add_group  'Models', 'app/models'
    add_group  'Controllers', 'app/controllers'
    add_group  'Helpers', 'app/helpers'
    add_group  'Views', 'app/views'
    add_group  'Mailers', 'app/mailers'
  end
end


ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'
require 'rspec/autorun'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

require 'capybara/poltergeist'

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, js_errors: true, inspector: true)
end

Capybara.default_driver    = :rack_test
Capybara.javascript_driver = :poltergeist

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  #config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # See database_cleaner.rb for details.
  config.use_transactional_fixtures = false

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Use the new expect() syntax.
  # - http://myronmars.to/n/dev-blog/2012/06/rspecs-new-expectation-syntax
  # - http://teaisaweso.me/blog/2013/05/27/rspecs-new-message-expectation-syntax/
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'random'
end

# Turn down the logging while testing.
Rails.logger.level = 4
