module ClientAuth
  class Resource < RestClient::Resource
    attr_reader :signer

    def initialize(url, options = {}, backwards_compatibility = nil, &block)
      @signer = options[:signer]
      super(url, options, backwards_compatibility, &block)
    end

    def post(payload, additional_headers = {}, &block)
      args = args_for(:post, payload, additional_headers)
      client_request(args).execute(&(block || @block))
    end

    def patch(payload, additional_headers = {}, &block)
      args = args_for(:patch, payload, additional_headers)
      client_request(args).execute(&(block || @block))
    end

    def client_request(args)
      ClientAuth::Request.new(args).tap do |client_request|
        signer.payload = client_request.payload
        client_request.init_headers(args, signer)
      end
    end

    def args_for(name, payload, additional_headers)
      headers = (options[:headers] || {}).merge(additional_headers)
      options.merge(method: name, url: url, payload: payload, headers: headers)
    end
  end
end
