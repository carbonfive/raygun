# -*- encoding: utf-8 -*-

File.expand_path('../lib', __FILE__).tap do |lib|
  $LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
end

require 'raygun/version'

Gem::Specification.new do |gem|
  gem.name          = "raygun"
  gem.version       = Raygun::VERSION
  gem.authors       = ["Christian Nelson", "Jonah Williams", "Jason Wadsworth"]
  gem.email         = ["christian@carbonfive.com"]
  gem.description   = %q{Carbon Five Rails application generator}
  gem.summary       = %q{Generates and customizes Rails applications with Carbon Five best practices baked in.}
  gem.homepage      = "https://github.com/carbonfive/raygun"
  gem.license       = 'MIT'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
