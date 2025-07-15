# frozen_string_literal: true

module Frontgo
  module Connection
    def post(uri, body, headers: {})
      request :post, uri, body, headers
    end

    def get(uri, params = {}, headers: {})
      response = @connection.get(uri, params, headers)
      response.body
    end

    def put(uri, body = {}, headers: {})
      request :put, uri, body, headers
    end

    def delete(uri, headers: {})
      request :delete, uri, nil, headers
    end

    private

    def request(method, url, body, headers)
      response = @connection.run_request method, url, body, headers
      response.body
    end
  end
end
