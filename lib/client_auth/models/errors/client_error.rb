module ClientAuth
  module Errors
    class ClientError < BaseError
      def initialize(status, detail)
        @status = status
        @title = self.class.name
        @detail = detail
      end
    end
  end
end
