# -*- encoding: utf-8 -*-

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'raygun/version'

Gem::Specification.new do |gem|
  gem.name          = "raygun"
  gem.version       = Raygun::VERSION
  gem.authors       = ["Christian Nelson", "Jonah Williams", "Jason Wadsworth"]
  gem.email         = ["christian@carbonfive.com"]
  gem.description   = %q{Carbon Five Rails application generator}
  gem.summary       = %q{Generates and customizes Rails applications with Carbon Five best practices baked in.}
  gem.homepage      = "https://github.com/carbonfive/raygun"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "thor"

  gem.add_development_dependency "guard-rspec"
  gem.add_development_dependency "godot"
end
