# frozen_string_literal: true

require "faraday"
require_relative "../frontgo/error"

module Frontgo
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
