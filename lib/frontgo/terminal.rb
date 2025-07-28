# frozen_string_literal: true

module Frontgo
  # @see https://docs.frontpayment.no/books/fpgo-connect/chapter/terminal-management
  module Terminal
    # @example Get terminal lists for organization
    #   client.get_terminal_lists("ORG2074299506")
    def get_terminal_lists(organization_uuid)
      get "api/v1/connect/terminal/lists/#{organization_uuid}"
    end

    # @example Create terminal order with callback
    #   client.create_terminal_order({
    #     products: { "0": { name: "Hair Wash", productId: "VFDDF", quantity: 1, rate: 42, tax: 0, amount: 42 } },
    #     orderSummary: { subTotal: 42.00, totalTax: 0.00, totalDiscount: 0.00, grandTotal: 42.00 },
    #     orderDate: "07 Apr, 2024",
    #     terminalUuid: "TRML1216693970",
    #     receiptPrint: false,
    #     sendOrderBy: { sms: false, email: true },
    #     customerDetails: {
    #       type: "private",
    #       name: "Kari Nordmann",
    #       email: "kari@example.com",
    #       countryCode: "+47",
    #       msisdn: "46567468",
    #       preferredLanguage: "en",
    #       address: { street: "Luramyrveien 65", zip: "4313", city: "Sandnes", country: "NO" }
    #     },
    #     callbackUrl: "https://example-callback.com"
    #   })
    def create_terminal_order(params)
      post "api/v1/connect/terminal/orders/create", params
    end

    # @example Cancel terminal order payment
    #   client.cancel_terminal_order("ODR123456789", { type: "payment" })
    def cancel_terminal_order(order_uuid, params)
      post "api/v1/connect/terminal/orders/cancel/#{order_uuid}", params
    end

    # @example Resend terminal order to terminal
    #   client.resend_terminal_order("ODR123456789")
    def resend_terminal_order(order_uuid)
      post "api/v1/connect/terminal/orders/resend/#{order_uuid}", {}
    end

    # @example Check payment status
    #   client.get_payment_status("ODR123456789")
    def get_payment_status(order_uuid)
      get "api/v1/connect/terminal/orders/payment-status/#{order_uuid}"
    end

    # @example Refund terminal order
    #   client.refund_terminal_order("ODR123456789", {
    #     type: "regular",
    #     grandTotal: 42,
    #     products: [{ id: 12, amount: 42 }],
    #     isReversal: false
    #   })
    # @example Reverse terminal payment
    #   client.refund_terminal_order("ODR123456789", {
    #     type: "regular",
    #     grandTotal: 42,
    #     products: [{ id: 12, amount: 42 }],
    #     isReversal: true
    #   })
    def refund_terminal_order(order_uuid, params)
      post "api/v1/connect/terminal/orders/refund/#{order_uuid}", params
    end

    # @example Check refund status
    #   client.get_refund_status("ODR123456789")
    def get_refund_status(order_uuid)
      get "api/v1/connect/terminal/orders/refund-status/#{order_uuid}"
    end

    # @example Cancel refund request
    #   client.cancel_refund_request("ODR123456789", { type: "refund" })
    def cancel_refund_request(order_uuid, params)
      post "api/v1/connect/terminal/orders/cancel/#{order_uuid}", params
    end
  end
end
