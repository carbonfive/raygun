# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment', __FILE__)

# Disable buffering for real time logging, see: https://devcenter.heroku.com/articles/logging#writing-to-your-log
$stdout.sync = true

# Optional Basic Auth - Enabled if BASIC_AUTH_PASSWORD is set. User is optional (any value will be accepted).
BASIC_AUTH_USER     = ENV['BASIC_AUTH_USER']
BASIC_AUTH_PASSWORD = ENV['BASIC_AUTH_PASSWORD']

if BASIC_AUTH_PASSWORD
  use Rack::Auth::Basic do |username, password|
    password == BASIC_AUTH_PASSWORD && (BASIC_AUTH_USER.blank? || username == BASIC_AUTH_USER)
  end
end

run AppPrototype::Application
