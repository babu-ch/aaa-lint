Gem::Specification.new do |spec|
  spec.name          = 'rubocop-aaa'
  spec.version       = '0.0.2'
  spec.authors       = ['babu-ch']
  spec.summary       = 'RuboCop cop enforcing the Arrange-Act-Assert pattern in test code.'
  spec.description   = 'A custom RuboCop cop that checks test blocks contain arrange/act/assert comments in order.'
  spec.license       = 'MIT'
  spec.homepage      = 'https://babu-ch.github.io/aaa-lint/guide/rubocop'

  spec.metadata['homepage_uri']      = spec.homepage
  spec.metadata['source_code_uri']   = 'https://github.com/babu-ch/aaa-lint/tree/main/packages/rubocop-aaa'
  spec.metadata['bug_tracker_uri']   = 'https://github.com/babu-ch/aaa-lint/issues'
  spec.metadata['documentation_uri'] = 'https://babu-ch.github.io/aaa-lint/guide/rubocop'

  spec.required_ruby_version = '>= 3.0'

  spec.files = Dir['lib/**/*.rb', 'config/*.yml', 'README.md']
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'rubocop', '~> 1.0'

  spec.add_development_dependency 'rspec', '~> 3.12'

  spec.metadata['rubygems_mfa_required'] = 'true'
end
