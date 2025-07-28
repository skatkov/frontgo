# frozen_string_literal: true

require_relative "frontgo/version"
require_relative "frontgo/connection"
require_relative "frontgo/order"
require_relative "frontgo/reservation"
require_relative "frontgo/subscription"
require_relative "frontgo/customer"
require_relative "frontgo/refund"
require_relative "frontgo/terminal"
require_relative "frontgo/credit"
require "faraday"

module Frontgo
  class Error < StandardError; end

  class Client
    include Connection
    include Order
    include Reservation
    include Subscription
    include Customer
    include Refund
    include Terminal
    include Credit

    def initialize(base_url, key:)
      @connection = Faraday.new(base_url) do |conn|
        conn.headers["Authorization"] = "Bearer #{key}"
        conn.request :json
        conn.response :json
        conn.response :raise_error
      end
    end
  end
end
