# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'malartu/version'

Gem::Specification.new do |spec|
  spec.name          = 'malartu'
  spec.version       = Malartu::VERSION
  spec.authors       = ['david-richey']
  spec.email         = ['david.richey@validic.com']

  spec.summary       = %q{Wrapper for Malartu API}
  spec.description   = %q{Ruby Wrapper for Malartu API}
  spec.homepage      = 'https://app.malartu.co/docs/api'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rspec', '~> 3.1'
  spec.add_development_dependency 'webmock', '~> 3.0'
  spec.add_dependency 'http', '~> 3.0'
end
