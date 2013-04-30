#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

AppPrototype::Application.load_tasks

# Disable schema.sql generation, unless we're in development.
# http://stackoverflow.com/questions/12413306/error-when-doing-rake-dbmigrate-on-heroku
Rake::Task['db:structure:dump'].clear unless Rails.env.development?

# Spec is the default rake target.
task(:default).clear
task default: 'spec'
