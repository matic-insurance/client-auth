module ConfigHelper
  def set_config(api_host = 'the-api-host', app_name = 'the-app-name')
    ClientAuth::Config.api_host = api_host
    ClientAuth::Config.app_name = app_name
    ClientAuth::Config.key = OpenSSL::PKey::RSA.new(512)
  end
end

RSpec.configure do |config|
  config.include ConfigHelper
end
