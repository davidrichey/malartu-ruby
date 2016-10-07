# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'malartu/version'

Gem::Specification.new do |spec|
  spec.name          = 'malartu'
  spec.version       = Malartu::VERSION
  spec.authors       = ['david-richey']
  spec.email         = ['david.richey@validic.com']

  spec.summary       = %q{Wrapper for Malartu Reporting API}
  spec.description   = %q{Wrapper for Malartu Reporting API}
  spec.homepage      = 'http://www.malartufunds.us/kpi/api/docs'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rspec'
  spec.add_dependency 'http'
end
