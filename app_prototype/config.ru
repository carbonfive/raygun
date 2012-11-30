# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)

# Disable buffering for real time logging, see: https://devcenter.heroku.com/articles/logging#writing-to-your-log
$stdout.sync = true

run AppPrototype::Application
