# frozen_string_literal: true

module Frontgo
  # @see https://docs.frontpayment.no/books/fpgo-connect/chapter/reservation-management
  module Reservation
    # @example Submit a new reservation
    #   client.submit_reservation({
    #     customerDetails: {
    #       type: "private",
    #       name: "Kari Nordmann",
    #       email: "kari@example.com",
    #       countryCode: "+47",
    #       msisdn: "46567468"
    #     },
    #     products: { "0": { name: "Test", rate: 1000, tax: 0, amount: 1000 } },
    #     orderSummary: { subTotal: 1000.00, totalTax: 0, grandTotal: 1000.00 },
    #     chargeValidity: "55",
    #     settings: { isChargePartiallyRefundable: true }
    #   })
    def submit_reservation(params)
      post "connect/reservations/submit", params
    end

    # @example Get reservation details by UUID
    #   client.get_reservation_details_by_uuid("RES3633019929")
    def get_reservation_details_by_uuid(uuid)
      get "connect/reservations/details/#{uuid}"
    end

    # @example Cancel a reservation
    #   client.cancel_reservation("RES123456789", {
    #     note: "Customer requested cancellation"
    #   })
    def cancel_reservation(uuid, params)
      post "connect/reservations/cancel/#{uuid}", params
    end

    # @example Capture funds from a reservation
    #   client.capture_reservation("RES123456789", {
    #     products: {
    #       "0": { id: 298, amount: 500 },
    #       "1": { id: 299, amount: 1500 }
    #     },
    #     grandTotal: 2000,
    #     additionalText: "Capture for services rendered"
    #   })
    def capture_reservation(uuid, params)
      post "connect/reservations/capture/#{uuid}", params
    end

    # @example Charge additional amount from reservation
    #   client.charge_reservation("RES123456789", {
    #     products: {
    #       "0": {
    #         name: "Additional Service",
    #         rate: 1500,
    #         tax: 0,
    #         amount: 1500
    #       }
    #     },
    #     grandTotal: 1500,
    #     additionalText: "Extra service charge"
    #   })
    def charge_reservation(uuid, params)
      post "connect/reservations/charge/#{uuid}", params
    end

    # @example Complete a reservation
    #   client.complete_reservation("RES123456789", {
    #     note: "Service completed successfully"
    #   })
    def complete_reservation(uuid, params)
      post "connect/reservations/complete/#{uuid}", params
    end

    # @example Resend reservation payment link
    #   client.resend_reservation("RES123456789", {
    #     countryCode: "+47",
    #     msisdn: "46567468",
    #     email: "customer@example.com"
    #   })
    def resend_reservation(uuid, params)
      post "connect/reservations/resend/#{uuid}", params
    end

    # @example Refund a reservation (from captured or charged amounts)
    #   client.refund_reservation("RES123456789", {
    #     type: "reservation",
    #     grandTotal: 500,
    #     products: [
    #       { id: 451, amount: 300 },
    #       { id: 452, amount: 200 }
    #     ],
    #     source: "charged",
    #     reference: "CHA3852658817"
    #   })
    def refund_reservation(uuid, params)
      post "connect/reservations/refund/#{uuid}", params
    end

    # @example Create reservation session for checkout
    #   client.create_session_for_reservation({
    #     customerDetails: {
    #       type: "private",
    #       name: "Kari Nordmann",
    #       email: "kari@example.com",
    #       countryCode: "+47",
    #       msisdn: "46567468"
    #     },
    #     products: { "0": { name: "Test", rate: 1000, tax: 0, amount: 1000 } },
    #     submitPayment: { via: "visa" },
    #     callback: {
    #       success: "https://example.com/success",
    #       failure: "https://example.com/failure"
    #     },
    #     settings: { isChargePartiallyRefundable: true }
    #   })
    def create_session_for_reservation(params)
      post "connect/reservations/create", params
    end

    # @example Get reservation history by time frame
    #   client.get_reservation_history_by_time_frame("1706674723", "1706761123")
    # @example Get last 24 hours (when no timestamps provided, defaults to last 24 hours)
    #   client.get_reservation_history_by_time_frame("", "")
    def get_reservation_history_by_time_frame(start_timestamp, end_timestamp)
      get "connect/reservations/history/#{start_timestamp}/#{end_timestamp}"
    end
  end
end
