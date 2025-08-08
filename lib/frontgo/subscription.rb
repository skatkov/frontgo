# frozen_string_literal: true

module Frontgo
  # @see https://docs.frontpayment.no/books/fpgo-connect/chapter/subscription-management
  module Subscription
    # @example Create a new subscription
    #   client.create_subscription({
    #     products: { "0": { name: "Monthly Service", rate: 2000, tax: 0, amount: 2000 } },
    #     billingFrequency: "month",
    #     numberOfRepeats: 12,
    #     customerDetails: { name: "John Doe", email: "john@example.com" }
    #   })
    def create_subscription(params)
      post "connect/subscription/submit", params
    end

    # @example Create subscription session for checkout
    #   client.create_session_for_subscription_payment({
    #     products: { "0": { name: "Premium Plan", rate: 1500, tax: 0, amount: 1500 } },
    #     billingFrequency: "month",
    #     submitPayment: { via: "visa" },
    #     callback: { success: "https://example.com/success", failure: "https://example.com/failure" }
    #   })
    def create_session_for_subscription_payment(params)
      post "connect/subscription/create", params
    end

    # @example Get all subscriptions
    #   client.get_subscription_list
    # @example Get ongoing subscriptions with pagination
    #   client.get_subscription_list('ongoing', { page: 2, customerName: 'John' })
    # @example Filter by phone and date range
    #   client.get_subscription_list(nil, { phone: '+47123456789', startDate: '2023-01-01', endDate: '2023-12-31' })
    def get_subscription_list(status = nil, params = {})
      endpoint = status ? "connect/subscriptions/list/#{status}" : "connect/subscriptions/list"
      get endpoint, params
    end

    # @example Get all failed payments
    #   client.get_failed_payment_list
    # @example Get invoiced failed payments with pagination
    #   client.get_failed_payment_list('invoiced', { page: 1, phone: '+47123456789' })
    # @example Filter by subscription UUID
    #   client.get_failed_payment_list(nil, { subscriptionUuid: 'SUB123456789' })
    def get_failed_payment_list(status = nil, params = {})
      endpoint = status ? "connect/subscriptions/failed/list/#{status}" : "connect/subscriptions/failed/list"
      get endpoint, params
    end

    # @example Get subscription details
    #   client.get_subscription_details_by_uuid('SUB123456789')
    def get_subscription_details_by_uuid(uuid)
      get "connect/subscriptions/details/#{uuid}"
    end

    # @example Get failed payment details
    #   client.get_failed_payment_details('ODR123456789')
    def get_failed_payment_details(order_uuid)
      get "connect/subscriptions/failed/details/#{order_uuid}"
    end

    # @example Resend subscription payment link
    #   client.resend_subscription('SUB123456789', {
    #     orderUuid: 'ODR123456789',
    #     countryCode: '+47',
    #     msisdn: '46567468',
    #     email: 'customer@example.com'
    #   })
    def resend_subscription(uuid, params)
      post "connect/subscriptions/resend/#{uuid}", params
    end

    # @example Cancel subscription
    #   client.cancel_subscription('SUB123456789', { note: 'Customer requested cancellation' })
    def cancel_subscription(uuid, params)
      post "connect/subscriptions/cancel/#{uuid}", params
    end

    # @example Refund specific subscription cycles
    #   client.refund_subscription_cycle('SUB123456789', {
    #     cycles: ['Cycle 1', 'Cycle 2'],
    #     amount: 200.00
    #   })
    def refund_subscription_cycle(uuid, params)
      post "connect/subscriptions/cycles/refund/#{uuid}", params
    end
  end
end
