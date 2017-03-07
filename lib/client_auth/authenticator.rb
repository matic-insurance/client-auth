module ClientAuth
  class Authenticator
    EXPIRATION = 10.minutes
    DELIMITER = ':'.freeze

    def initialize(request, public_key)
      @request = request
      @public_key = public_key
    end

    def authenticate!
      validate_client_name!
      validate_timestamp!
      validate_signature!
      true
    end

    private

    def validate_client_name!
      raise_error('No client name') unless client_name
    end

    def validate_timestamp!
      raise_error('No timestamp') unless timestamp
      raise_error('Timestamp is expired') if expired_timestamp?
    end

    def validate_signature!
      raise_error('Signature is missing') unless signature.present?
      raise_error('Invalid signature') unless signature_valid?
    end

    def timestamp
      Integer(@request.headers['X-Timestamp'].to_s)
    rescue ArgumentError
      nil
    end

    def expired_timestamp?
      (Time.current - Time.at(timestamp)) > EXPIRATION
    end

    def signature_valid?
      key = OpenSSL::PKey::RSA.new(@public_key)
      key.verify(OpenSSL::Digest::SHA256.new, signature, concat_secret_string)
    end

    def concat_secret_string
      [
        client_name,
        @request.request_method.upcase,
        @request.fullpath,
        timestamp
      ].join(DELIMITER)
    end

    def signature
      [@request.headers['X-Signature']].pack('H*')
    end

    def client_name
      @request.headers['X-Client']
    end

    def raise_error(message)
      raise ClientAuth::Errors::PreconditionFailed.new('412', message)
    end
  end
end
