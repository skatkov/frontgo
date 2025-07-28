# frozen_string_literal: true

require "test_helper"

class TestFrontgo < Minitest::Test
  def test_create_session_for_one_time_payment_link
    VCR.use_cassette("create_session_for_one_time_payment_link") do
      response = client.create_session_for_one_time_payment_link({
          products: [
              {
                  name: "Router",
                  productId: "P-1",
                  quantity: "1",
                  discount: 0,
                  tax: 0,
                  amount: 1500
              }
          ],
          orderSummary: {
              subTotal: "1500.00",
              totalTax: "1500.00",
              totalDiscount: "0.00",
              grandTotal: "1500.00"
          },
          orderDate: "2 Aug, 2023",
          dueDateForPaymentLink: "1691125906",
          sendOrderBy: {
              sms: false,
              email: false,
              invoice: true
          },
          invoiceAsPaymentOption: true,
          isCreditCheckAvailable: false,
          customerDetails: {
              type: "private",
              countryCode: "+47",
              msisdn: "46567468",
              email: "[email protected]",
              name: "Kari Nordmann",
              preferredLanguage: "en",
              personalNumber: nil,
              organizationId: nil,
              address: {
                  street: "Luramyrveien 65",
                  zip: "4313",
                  city: "Sandnes",
                  country: "NO"
              }
          },
          invoiceReferences: nil,
          internalReferences: nil,
          invoiceInterval: 0,
          separateInvoices: true,
          submitPayment: {
              via: "invoice",
              currency: "NOK"
          },
          callback: {
              callbackUrl: "https://www.frontpayment.no/callback",
              success: "https://www.frontpayment.no/success",
              failure: "https://www.frontpayment.no/failure"
          }
      })
    end
  end

  private

  def client
    @client ||= Frontgo::Client.new(
      "https://demo-api.frontpayment.no/", key: (ENV['FRONTGO_API_KEY'] || 'key')
    )
  end
end
