Gem::Specification.new do |spec|
  spec.name          = 'client-auth'
  spec.version       = '1.0.0'
  spec.authors       = ['Yuriy Lavryk']
  spec.email         = ['yuriy@getmatic.com']

  spec.summary       = 'Authentication client'
  spec.description   = 'Authentication for matic clients'
  spec.homepage      = 'https://github.com/matic-insurance/client-auth'

  s.files = Dir['lib/**/*.rb']
  s.files += Dir['README.markdown']

  spec.require_paths = 'lib'

  s.add_dependency 'rest-client'
  s.add_dependency 'activesupport'
  s.add_dependency 'active_model_serializers', '0.10.2'
end
