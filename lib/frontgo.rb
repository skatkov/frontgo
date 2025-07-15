# frozen_string_literal: true

require_relative "frontgo/version"
require_relative "frontgo/connection"
require_relative "frontgo/orders"

module Frontgo
  class Error < StandardError; end

  class Client
    include Connection
    include Orders

    def initialize(base_url, key:)
      @connection = Faraday.new(base_url) do |conn|
        conn.headers['Authorization'] = "Bearer #{key}"
        conn.request :json
        conn.response :raise_error
        conn.response :json
      end
    end
  end
end
