# frozen_string_literal: true

module Frontgo
  module Connection
    def post(uri, body, headers: {})
      request :post, uri, body, headers
    end

    def get(uri, params = {}, headers: {})
      @connection.get(uri, params, headers)
    end

    def put(uri, body = {}, headers: {})
      request :put, uri, body, headers
    end

    def delete(uri, headers: {})
      request :delete, uri, nil, headers
    end

    def url_prefix
      @connection.url_prefix
    end

    private

    def request(method, url, body, headers)
      @connection.run_request method, url, body, headers
    end
  end
end
