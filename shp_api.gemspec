# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'shp_api/version'

Gem::Specification.new do |spec|
  spec.name          = "shp_api"
  spec.version       = ShpApi::VERSION
  spec.authors       = ["Gert Joergensen"]
  spec.email         = ["gert@shape.dk"]
  spec.description   = %q{Common ruby code for building rails APIs}
  spec.summary       = %q{Common API methods}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  
  spec.add_dependency("rails", "~> 4.0")
  spec.add_dependency("jbuilder", "~> 2.0")
end
