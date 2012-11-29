# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)

# Disable buffering for real time logging (foreman and heroku).
$stdout.sync = true

run AppPrototype::Application
