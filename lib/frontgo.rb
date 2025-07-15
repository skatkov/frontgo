# frozen_string_literal: true

require_relative "frontgo/version"
require_relative "frontgo/connection"
require_relative "frontgo/orders"
require_relative "frontgo/reservations"
require_relative "frontgo/subscription"
require_relative "frontgo/customers"
require_relative "frontgo/refund"


module Frontgo
  class Error < StandardError; end

  class Client
    include Connection
    include Orders
    include Reservations
    include Subscription
    include Customers
    include Refund

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
