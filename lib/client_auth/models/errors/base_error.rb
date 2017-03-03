module ClientAuth
  module Errors
    class BaseError < StandardError
      attr_accessor :status, :title, :detail

      alias message detail

      def initialize(status, detail)
        @status = status
        @title = self.class.name
        @detail = detail
      end

      def inspect
        "#{status} #{title}: '#{detail}'"
      end

      def headers
        {}
      end
    end
  end
end
