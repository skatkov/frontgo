# frozen_string_literal: true

require_relative "frontgo/version"
require_relative "frontgo/connection"
require_relative "frontgo/orders"
require_relative "frontgo/reservations"


module Frontgo
  class Error < StandardError; end

  class Client
    include Connection
    include Orders
    include Reservations

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
