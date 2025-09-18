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

    # Initializes the client.
    #
    # @param key [String] Bearer key
    # @param demo [Boolean] Optionally target the demo environment
    #
    # @return [Client] A fully initialized client

    def initialize(key:, demo: false)
      @demo = demo || false
      @connection = Faraday.new(base_url) do |conn|
        conn.headers["Authorization"] = "Bearer #{key}"
        conn.request :json
        conn.response :json
      end
    end

    private

    # Checks if the client is using the demo environment
    #
    # @return [Boolean]
    def demo?
      @demo
    end

    # Retrieves the base URL to use when making api requests.
    #
    # @return [String]
    def base_url
      if demo?
        "https://demo-api.frontpayment.no/api/v1/"
      else
        "https://apigo.frontpayment.no/api/v1"
      end
    end
  end
end
