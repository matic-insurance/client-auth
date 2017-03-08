module ClientAuth
  class Signer
    attr_reader :client_name

    def initialize(method, path, params)
      @method = method.upcase
      @path = path
      @params = params
    end

    def headers
      raise NotImplementedError, 'Client name not configured' unless client_name

      {
        'X-Client' => client_name,
        'X-Timestamp' => timestamp,
        'X-Signature' => signature
      }
    end

    def configure(client_key, client_name)
      @client_key = client_key
      @client_name = client_name
    end

    private

    def timestamp
      @timestamp ||= Time.now.to_i.to_s
    end

    def signature
      raise NotImplementedError, 'Client key not configured' unless @client_key
      key.sign(OpenSSL::Digest::SHA256.new, secret_string).unpack('H*').first
    end

    def key
      @key ||= OpenSSL::PKey::RSA.new(@client_key)
    end

    def secret_string
      [
        client_name,
        @method,
        fullpath,
        request_body,
        timestamp
      ].join(ClientAuth::Authenticator::DELIMITER)
    end

    def request_body
      return if @method == 'GET'
      @params.to_json
    end

    def fullpath
      fullpath = [safe_path]
      fullpath.push(@params.to_query) if @method == 'GET' && @params.present?
      fullpath.join('?')
    end

    def safe_path
      '/' + URI.encode(@path).gsub(%r{\A\/}, '')
    end
  end
end
