# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'brickset/version'

Gem::Specification.new do |spec|
  spec.name          = "brickset"
  spec.version       = Brickset::VERSION
  spec.authors       = ["dbwinger"]
  spec.email         = ["dbwinger@gmail.com"]
  spec.summary       = %q{Ruby wrapper for the Brickset.com v2 API}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.1"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "byebug"
  
  spec.add_dependency "nokogiri"
  spec.add_dependency "httparty"
end
