# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mutiny/version'

Gem::Specification.new do |spec|
  spec.name          = "mutiny"
  spec.version       = Mutiny::VERSION
  spec.authors       = ["Louis Rose"]
  spec.email         = ["louis.rose@york.ac.uk"]
  spec.description   = %q{A tiny and experimental mutation testing framework for exploring research ideas.}
  spec.summary       = %q{A tiny mutation testing framework for Ruby}
  spec.homepage      = "https://github.com/mutiny/mutiny"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "parser", "~> 2.2.0"
  spec.add_runtime_dependency "unparser", "~> 0.2.2"
  spec.add_runtime_dependency "gli", "~> 2.13.0"
  
  spec.add_development_dependency "bundler", "~> 1.9.0"
  spec.add_development_dependency "rake", "~> 10.4.2"
  spec.add_development_dependency "rspec", "~> 3.2.0"
  spec.add_development_dependency "aruba", "~> 0.6.0"
  spec.add_development_dependency "codeclimate-test-reporter", "~> 0.4.6"
  spec.add_development_dependency "rubocop", "~> 0.29.0"
end
