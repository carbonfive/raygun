# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment', __FILE__)

# Redirect to the custom (canonical) hostname.
use Rack::CanonicalHost, ENV['HOSTNAME'] if ENV['HOSTNAME']

# Optional Basic Auth - Enabled if BASIC_AUTH_PASSWORD is set. User is optional (any value will be accepted).
BASIC_AUTH_USER     = ENV['BASIC_AUTH_USER']
BASIC_AUTH_PASSWORD = ENV['BASIC_AUTH_PASSWORD']

if BASIC_AUTH_PASSWORD
  use Rack::Auth::Basic do |username, password|
    password == BASIC_AUTH_PASSWORD && (BASIC_AUTH_USER.blank? || username == BASIC_AUTH_USER)
  end
end

run AppPrototype::Application
