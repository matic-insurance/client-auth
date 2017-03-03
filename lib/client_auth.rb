module ClientAuth
end

require 'active_support/all'
require 'rest-client'

require 'client_auth/models/errors/base_error'

Dir["#{File.dirname(__FILE__)}/**/*.rb"].each { |file| require file }
