module ClientAuth
  module Errors
    class InternalServerError < BaseError
      def initialize(message = 'Internal server error')
        @status = 500
        @title = self.class.name
        @detail = message
      end
    end
  end
end
