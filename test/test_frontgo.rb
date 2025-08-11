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

      assert response.success?

      response.body.tap do |body|
        assert_equal "OK", body["status_message"]
        assert_equal "Order Submitted Successfully", body["message"]
        assert_equal true, body["is_data"]

        assert_match(/^ODR\d+$/, body.dig("data", "orderUuid"))
        assert_match(/^CSRT\d+$/, body.dig("data", "customerUuid"))
        assert_match(/^https:\/\//, body.dig("data", "paymentUrl"))
      end
    end
  end

  def test_get_order_status_by_uuid
    VCR.use_cassette("get_order_status_by_uuid") do
      order_uuid = "ODR1649249709"

      response = client.get_order_status_by_uuid(order_uuid)
      assert response.success?

      response.body.tap do |body|
        assert_equal "OK", body["status_message"]
        assert_equal true, body["is_data"]
        assert_equal order_uuid, body.dig("data", "uuid")
      end
    end
  end

  def test_demo_base_url
    demo_client = Frontgo::Client.new(key: client_key, demo: true)
    assert_equal "https://demo-api.frontpayment.no/api/v1/", demo_client.url_prefix.to_s
  end

  def test_production_base_url
    prod_client = Frontgo::Client.new(key: client_key, demo: false)
    assert_equal "https://apigo.frontpayment.no/api/v1", prod_client.url_prefix.to_s
  end

  def test_default_base_url
    default_client = Frontgo::Client.new(key: client_key)
    assert_equal "https://apigo.frontpayment.no/api/v1", default_client.url_prefix.to_s
  end

  private

  def client
    @client ||= Frontgo::Client.new(key: client_key, demo: true)
  end

  def client_key
    ENV["FRONTGO_API_KEY"] || "key"
  end
end
