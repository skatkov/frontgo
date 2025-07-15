# frozen_string_literal: true

module Frontgo
  # @see https://docs.frontpayment.no/books/fpgo-connect/chapter/refund-management
  module Refund
    # @example Request refund approval for regular order
    #   client.request_refund_approval("ODR123456789", {
    #     type: "regular",
    #     grandTotal: 55,
    #     message: "refundRejectionForWeeklyThresholdExceed",
    #     products: [
    #       { id: 451, amount: 30 },
    #       { id: 452, amount: 25 }
    #     ]
    #   })
    # @example Request refund approval for reservation
    #   client.request_refund_approval("ODR123456789", {
    #     type: "reservation",
    #     grandTotal: 100,
    #     message: "refundRejectionForWeeklyThresholdExceed",
    #     products: [
    #       { id: 451, amount: 60 },
    #       { id: 452, amount: 40 }
    #     ],
    #     source: "charged",
    #     reference: "CHA3852658817"
    #   })
    def request_refund_approval(order_uuid, params)
      post "api/v1/orders/refund/request/approval/#{order_uuid}", params
    end
  end
end