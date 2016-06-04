# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jf/version'

Gem::Specification.new do |spec|
  spec.name          = "jf"
  spec.version       = Jf::VERSION
  spec.authors       = ["timakin"]
  spec.email         = ["timaki.st@gmail.com"]

  spec.summary       = "JSON formatter on CLI with dead simple command."
  spec.description   = "Format JSON with dead simple command"
  spec.homepage      = "https://github.com/timakin/jf"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  spec.executables   = ["jf"]
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
end
