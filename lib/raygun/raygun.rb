require 'rails/generators'
require 'rails/generators/rails/app/app_generator'

[
  'helpers/ruby_version_helpers',
  'actions',
  'app_builder',
  'generators/app_generator'
].each do |lib_path|
  require File.expand_path(lib_path, File.dirname(__FILE__))
end
