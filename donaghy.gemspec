# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'donaghy/version'

Gem::Specification.new do |spec|
  spec.name          = "donaghy"
  spec.version       = Donaghy::VERSION
  spec.authors       = ["Topper Bowers"]
  spec.email         = ["topper@toppingdesign.com"]
  spec.summary       = %q{TODO: Write a short summary. Required.}
  spec.description   = %q{TODO: Write a longer description. Optional.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "celluloid", "~> 0.16"
  spec.add_dependency "bunny", "~> 1.7.0"
  spec.add_dependency "configliere"
  spec.add_dependency "activesupport", "~> 4.2"
  spec.add_dependency "hashie", "~> 3.4.1"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.2"
end
