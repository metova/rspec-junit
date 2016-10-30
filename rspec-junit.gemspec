# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rspec/junit/version'

Gem::Specification.new do |spec|
  spec.name          = 'rspec-junit'
  spec.version       = RSpec::JUnit::VERSION
  spec.authors       = ['Logan Serman']
  spec.email         = ['logan.serman@metova.com']

  spec.summary       = 'Provides a JUnit formatter for RSpec'
  spec.description   = spec.summary
  spec.homepage      = 'https://github.com/metova/rspec-junit'
  spec.license       = 'MIT'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'builder'
  spec.add_dependency 'rspec', '>= 3'

  spec.add_development_dependency 'bundler', '~> 1.13'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'timecop'
end
