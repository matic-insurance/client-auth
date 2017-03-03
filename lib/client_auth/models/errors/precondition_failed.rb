module ClientAuth
  module Errors
    class PreconditionFailed < RestClient::Exception
      def initialize(response = nil, initial_response_code = nil, message = nil)
        super(response, initial_response_code)
        self.message = message
      end
    end
  end
end
