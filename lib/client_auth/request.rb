module ClientAuth
  class Request < RestClient::Request

    def init_headers(args, signer)
      @headers = (args[:headers] || {}).dup
      @headers.merge!(signer.headers)

      if args[:url]
        @url = process_url_params(normalize_url(args[:url]), @headers)
      else
        raise ArgumentError, 'must pass :url'
      end
      parse_url_with_auth!(url)
      @cookie_jar = process_cookie_args!(@uri, @headers, args)
      @processed_headers = make_headers @headers
    end

  end
end