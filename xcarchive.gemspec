# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'xcarchive/version'

Gem::Specification.new do |spec|
  spec.name          = "xcarchive"
  spec.version       = Xcarchive::VERSION
  spec.authors       = ["jaderfeijo"]
  spec.email         = ["jader.feijo@gmail.com"]

  spec.summary       = "An Xcode archive management tool"
  spec.description   = "A command line utility for managing Xcode archives"
  spec.homepage      = "https://github.com/jaderfeijo/xcarchive"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
