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
require "faraday/retry"

require_relative "middleware/raise_error"

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
        # We're using default settings, just adding 'retry_if" option.
        # Originally faraday only retries for TimeoutError's, we're extending it to all ServerErrors
        conn.request :retry, max: 2,
          interval: 0.05,
          interval_randomness: 0.5,
          backoff_factor: 2,
          retry_if: ->(_env, exception) { exception.try(:retriable?) }

        conn.request :json
        conn.response :json
        conn.response :frontgo_raise_error
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
