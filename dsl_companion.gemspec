# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dsl_companion/version'

Gem::Specification.new do |spec|
  spec.name          = "dsl_companion"
  spec.version       = DSLCompanion::VERSION
  spec.authors       = ["Laurent B."]
  spec.email         = ["lbnetid+gh@gmail.com"]
  spec.summary       = %q{Provides a customizable interpreter to run your own internal DSLs.}
  spec.description   = %q{The goal of this gem is to provide a versatile DSL interpreter.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency 'rspec'
end
