module ClientAuth
  class Client
    attr_reader :config

    delegate :api_host, :app_name, :key, to: :config

    def initialize(config)
      @config = config
    end

    def get(path, params = {})
      resource = resource('GET', path, params)
      with_rescue { resource[URI.escape(path)].get(params: params) }
    end

    def post(path, params = {})
      resource = resource('POST', path, params)
      with_rescue { resource[URI.escape(path)].post(params.to_json) }
    end

    def patch(path, params = {})
      resource = resource('PATCH', path, params)
      with_rescue { resource[URI.escape(path)].patch(params.to_json) }
    end

    protected

    def with_rescue
      yield
    rescue RestClient::NotFound, RestClient::PreconditionFailed,
           RestClient::UnprocessableEntity => exception
      raise ClientAuth::ErrorSerializer.deserialize(exception.response)
    rescue RestClient::Exception => exception
      raise ClientAuth::Errors::ClientError.new(exception.http_code, exception.message)
    end

    def resource(method, path, params)
      signer = ClientAuth::Signer.new(method, path, params)
      signer.configure(key, app_name)
      headers = signer.headers.merge(content_type: :json, accept: :json)
      RestClient::Resource.new(api_host, headers: headers)
    end
  end
end
