# frozen_string_literal: true

module Frontgo
  # @see https://docs.frontpayment.no/books/fpgo-connect/chapter/order-management
  module Orders
    # @example Create a one-time payment link session
    #   client.create_session_for_one_time_payment_link({
    #     products: [{ name: "Router", rate: 4500, tax: 12, amount: 4500 }],
    #     orderSummary: { subTotal: 4017.86, totalTax: 482.14, grandTotal: 4500.00 },
    #     customerDetails: { name: "Kari Nordmann", email: "kari@example.com" },
    #     submitPayment: { via: "visa", currency: "NOK" },
    #     callback: { success: "https://example.com/success", failure: "https://example.com/failure" }
    #   })
    def create_session_for_one_time_payment_link(params)
      post "api/v1/connect/orders/regular/submit", params
    end

    # @example Create an invoice order session
    #   client.create_session_for_invoice_order({
    #     products: [{ name: "Router", rate: 4500, tax: 12, amount: 4500 }],
    #     orderSummary: { subTotal: 4017.86, totalTax: 482.14, grandTotal: 4500.00 },
    #     customerDetails: { name: "Kari Nordmann", email: "kari@example.com" },
    #     submitPayment: { via: "invoice", currency: "NOK" },
    #     invoiceInterval: 0,
    #     separateInvoices: true
    #   })
    def create_session_for_invoice_order(params)
      post "api/v1/connect/orders/regular/submit", params
    end

    # Can be filtered by status type as query (?type=)
    # @example Get all order statuses
    #   client.get_all_order_status
    # @example Get only paid orders
    #   client.get_all_order_status(type: 'paid')
    # @example Get only invoiced orders
    #   client.get_all_order_status(type: 'invoiced')
    def get_all_order_status(params = {})
      get "api/v1/connect/orders/status", params
    end

    # @example Get order status by UUID
    #   client.get_order_status_by_uuid("ODR347888404")
    def get_order_status_by_uuid(uuid)
      get "api/v1/connect/orders/status/#{uuid}"
    end

    # @example Get detailed order information
    #   client.get_order_details_by_uuid("ODR986760186")
    def get_order_details_by_uuid(uuid)
      get "api/v1/connect/orders/details/#{uuid}"
    end

    # @example Send E-Faktura invoice
    #   client.send_e_faktura({
    #     products: { "0": { name: "Hair Wash", rate: 51, tax: 0, amount: 51 } },
    #     customerDetails: { 
    #       type: "private", 
    #       name: "Kari Nordmann", 
    #       email: "kari@example.com",
    #       personalNumber: "12345678901"
    #     },
    #     orderSummary: { subTotal: 51.00, totalTax: 0.00, grandTotal: 51.00 }
    #   })
    def send_e_faktura(params)
      post "api/v1/connect/orders/invoice/create/faktura", params
    end

    # @example Send EHF invoice for corporate customers
    #   client.send_ehf_invoice({
    #     products: { "0": { name: "Hair Wash", rate: 51, tax: 0, amount: 51 } },
    #     customerDetails: { 
    #       type: "corporate", 
    #       name: "Kari Nordmann", 
    #       email: "kari@example.com",
    #       organizationId: "123456789"
    #     },
    #     orderSummary: { subTotal: 51.00, totalTax: 0.00, grandTotal: 51.00 }
    #   })
    def send_ehf_invoice(params)
      post "api/v1/connect/orders/invoice/create/ehf", params
    end

    # @example Cancel an order
    #   client.cancel_order("ODR123456789", { 
    #     cancellationNote: "Customer requested cancellation" 
    #   })
    def cancel_order(order_uuid, params)
      post "api/v1/connect/orders/cancel/#{order_uuid}", params
    end

    # @example Send payment link to customer
    #   client.send_payment_link({
    #     products: { "0": { name: "Hair Wash", rate: 51, tax: 0, amount: 51 } },
    #     customerDetails: { 
    #       type: "private", 
    #       name: "Kari Nordmann", 
    #       email: "kari@example.com"
    #     },
    #     sendOrderBy: { sms: true, email: false, invoice: false },
    #     orderSummary: { subTotal: 51.00, totalTax: 0.00, grandTotal: 51.00 }
    #   })
    def send_payment_link(params)
      post "api/v1/connect/orders/payment-link/create", params
    end

    # @example Send regular invoice
    #   client.send_invoice({
    #     products: { "0": { name: "Hair Wash", rate: 51, tax: 0, amount: 51 } },
    #     customerDetails: { 
    #       type: "private", 
    #       name: "Kari Nordmann", 
    #       email: "kari@example.com"
    #     },
    #     sendOrderBy: { sms: false, email: false, invoice: true },
    #     invoiceInterval: 0,
    #     separateInvoices: true
    #   })
    def send_invoice(params)
      post "api/v1/connect/orders/invoice/create", params
    end

    # @example Resend payment link to customer
    #   client.resend_payment_link("ODR123456789", {
    #     countryCode: "+47",
    #     msisdn: "46567468",
    #     email: "customer@example.com"
    #   })
    def resend_payment_link(uuid, params)
      post "api/v1/connect/orders/resend/#{uuid}", params
    end

    # @example Refund an order (full or partial)
    #   client.refund_order("ODR123456789", {
    #     type: "regular",
    #     grandTotal: 55,
    #     products: [
    #       { id: 451, amount: 30 },
    #       { id: 452, amount: 25 }
    #     ]
    #   })
    def refund_order(uuid, params)
      post "api/v1/connect/orders/refund/#{uuid}", params
    end

    # @example Get invoice number for an order
    #   client.get_invoice_number_by_uuid("ODR2005869234")
    def get_invoice_number_by_uuid(uuid)
      get "api/v1/connect/orders/invoice-number/#{uuid}"
    end
  end
end
