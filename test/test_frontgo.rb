# frozen_string_literal: true

require "test_helper"

class TestFrontgo < Minitest::Test
  def test_create_session_for_one_time_payment_link
    VCR.use_cassette("create_session_for_one_time_payment_link") do
      response = client.create_session_for_one_time_payment_link({
          products: [
              {
                  name: "Framework 13 Laptop",
                  productId: "P-1",
                  quantity: "1",
                  rate: 1500,
                  discount: 0,
                  tax: 0,
                  amount: 1500
              }
          ],
          orderSummary: {
              subTotal: "1500.00",
              totalTax: "0.00",
              totalDiscount: "0.00",
              shippingCost: "0.00",
              grandTotal: "1500.00"
          },
          orderDate: "02 Aug, 2023",
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
              email: "kari.nordmann@example.com",
              name: "Kari Nordmann",
              preferredLanguage: "en",
              personalNumber: "12345678901",
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

      # Verify successful response
      assert_equal 201, response["status_code"]
      assert_equal "OK", response["status_message"]
      assert_equal "Order Submitted Successfully", response["message"]
      assert_equal true, response["is_data"]

      # Verify UUID formats
      assert_match /^ODR\d+$/, data["orderUuid"]
      assert_match /^CSRT\d+$/, data["customerUuid"]
      assert_match /^https:\/\//, data["paymentUrl"]
    end
  end

  private

  def client
    @client ||= Frontgo::Client.new(
      "https://demo-api.frontpayment.no/", key: (ENV['FRONTGO_API_KEY'] || 'key')
    )
  end
end
