Gem::Specification.new do |spec|
  spec.name          = 'rubocop-aaa'
  spec.version       = '0.0.1'
  spec.authors       = ['babu-ch']
  spec.summary       = 'RuboCop cop enforcing the Arrange-Act-Assert pattern in test code.'
  spec.description   = 'A custom RuboCop cop that checks test blocks contain arrange/act/assert comments in order.'
  spec.license       = 'MIT'
  spec.homepage      = 'https://github.com/babu-ch/aaa-lint'

  spec.required_ruby_version = '>= 3.0'

  spec.files = Dir['lib/**/*.rb', 'config/*.yml', 'README.md']
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'rubocop', '>= 1.0'

  spec.add_development_dependency 'rspec', '~> 3.12'

  spec.metadata['rubygems_mfa_required'] = 'true'
end
