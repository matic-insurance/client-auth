module ClientAuth
  module Config
    class << self
      attr_accessor :api_host, :app_name, :key

      def inspect
        "ClientAuth::Config: {api_host: #{api_host}, app_name: #{app_name}, key: #{key}}"
      end
    end
  end
end
