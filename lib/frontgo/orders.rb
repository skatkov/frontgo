# frozen_string_literal: true

module Frontgo
  # @see
  # https://docs.frontpayment.no/books/fpgo-connect/chapter/order-management
  module Orders
    def create_session_for_one_time_payment_link(params)
      post "api/v1/connect/orders/regular/submit", params
    end

    def create_session_for_invoice_order(params)
      post "api/v1/connect/orders/regular/submit", params
    end

    # Can be filtered by status type as query (?type=)
    def get_all_order_status(params = {})
      get "api/v1/connect/orders/status", params
    end

    def get_order_status_by_uuid(uuid)
      get "api/v1/connect/orders/status/#{uuid}"
    end

    def get_order_details_by_uuid(uuid)
      get "api/v1/connect/orders/details/#{uuid}"
    end

    def send_e_faktura(params)
      post "api/v1/connect/orders/invoice/create/faktura", params
    end

    def send_ehf_invoice(params)
      post "api/v1/connect/orders/invoice/create/ehf", params
    end

    def cancel_order(order_uuid, params)
      post "api/v1/connect/orders/cancel/#{order_uuid}", params
    end

    def send_payment_link(params)
      post "api/v1/connect/orders/payment-link/create", params
    end

    def send_invoice(params)
      post "api/v1/connect/orders/invoice/create", params
    end

    def resend_payment_link(uuid, params)
      post "api/v1/connect/orders/resend/#{uuid}", params
    end

    def refund_order(uuid, params)
      post "api/v1/connect/orders/refund/#{uuid}", params
    end

    def get_invoice_number_by_uuid(uuid)
      get "api/v1/connect/orders/invoice-number/#{uuid}"
    end
  end
end
