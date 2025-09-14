# frozen_string_literal: true

require "faraday"

module Frontgo
  class Error < StandardError
    # @param response [Faraday::response]
    def self.raise_if_error_response!(response)
      klass = case response.status
      when 400..499
        ClientError
      when 500..599
        ServerError
      else
        return
      end

      raise klass.new(response)
    end

    def initialize(response)
      body = response.body

      @json_body = JSON.parse(body)

      message = <<~EOS
        The FrontGo resource responded with a #{response.status} status, body was:

        #{JSON.pretty_generate(@json_body || body)}
      EOS

      super(message)
    rescue JSON::ParserError
      message = <<~EOS
        The FrontGo resource responded with a #{response.status} status, body was:

        #{body}

        This response could not be parsed as JSON error, so it's probably an intermittent HTML response
        from a proxy server or a networking error.
      EOS

      super(message)
    end

    def retriable?
      false
    end
  end

  class ClientError < Error; end

  class ServerError < Error
    def retriable?
      true
    end
  end

  module RaiseError
    class Middleware < ::Faraday::Middleware
      def on_complete(env)
        if env[:status] >= 400
          Frontgo::Error.raise_if_error_response!(env)
        end
      end
    end
  end
end

Faraday::Response.register_middleware(frontgo_raise_error: Frontgo::RaiseError::Middleware)
