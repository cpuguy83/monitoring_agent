# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'agent/version'

Gem::Specification.new do |spec|
  spec.name          = "monitoring_agent"
  spec.version       = Agent::VERSION
  spec.authors       = ["Brian Goff"]
  spec.email         = ["cpuguy83@gmail.com"]
  spec.description   = %q{Monitoring Agent}
  spec.summary       = %q{Monitoring Agent}
  spec.homepage      = "http://www.github.com/cpuguy83/monitoring_agent"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rpsec-given"

  spec.add_runtime_dependency "celluoid", "~> 0.15.0"
  spec.add_runtime_dependency "activesupport"
end
