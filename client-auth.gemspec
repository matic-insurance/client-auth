Gem::Specification.new do |spec|
  spec.name          = 'client-auth'
  spec.version       = '1.0.1'
  spec.authors       = ['Yuriy Lavryk']
  spec.email         = ['yuriy@getmatic.com']

  spec.summary       = 'Authentication client'
  spec.description   = 'Authentication for matic clients'
  spec.homepage      = 'https://github.com/matic-insurance/client-auth'

  spec.files = Dir['lib/**/*.rb']
  spec.files += Dir['README.markdown']

  spec.require_paths = 'lib'

  spec.add_dependency 'rest-client'
  spec.add_dependency 'activesupport'

  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rspec-its', '~> 1.2'
  spec.add_development_dependency 'webmock'
  spec.add_development_dependency 'rubocop', '~> 0.46'
  spec.add_development_dependency 'rubocop-rspec', '~> 1.8'
end
