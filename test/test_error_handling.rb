# frozen_string_literal: true

require "test_helper"
require "webmock/minitest"

class TestFrontgoErrorHandling < Minitest::Test
  def setup
    WebMock.disable_net_connect!(allow_localhost: true)
    VCR.turn_off!
  end

  def teardown
    WebMock.allow_net_connect!
    VCR.turn_on!
  end

  def test_create_session_raises_exception_on_timeout_error
    stub_request(:post, "https://demo-api.frontpayment.no/api/v1/connect/orders/regular/submit")
      .to_timeout

    assert_raises(Faraday::ConnectionFailed) do
      client.create_session_for_one_time_payment_link(valid_params)
    end
  end

  def test_create_session_raises_exception_on_connection_error
    stub_request(:post, "https://demo-api.frontpayment.no/api/v1/connect/orders/regular/submit")
      .to_raise(Faraday::ConnectionFailed.new("Connection refused"))

    assert_raises(Faraday::ConnectionFailed) do
      client.create_session_for_one_time_payment_link(valid_params)
    end
  end

  def test_create_session_raises_exception_on_server_error_500
    stub_request(:post, "https://demo-api.frontpayment.no/api/v1/connect/orders/regular/submit")
      .to_return(
        status: 500,
        body: JSON.generate({
          status_code: 500,
          status_message: "Internal Dependency Error",
          message: "Internal Error Occurred Please Try Again Later",
          is_error: true,
          errors: {
            happenedAt: "String",
            internalErrorDetails: "Array"
          }
        }),
        headers: {"Content-Type" => "application/json"}
      )

    error = assert_raises(Frontgo::ServerError) do
      client.create_session_for_one_time_payment_link(valid_params)
    end

    assert_match(/500/, error.message)
    assert_match(/Internal Dependency Error/, error.message)
    assert_match(/Internal Error Occurred Please Try Again Later/, error.message)
  end

  def test_create_session_raises_exception_on_server_error_510
    stub_request(:post, "https://demo-api.frontpayment.no/api/v1/connect/orders/regular/submit")
      .to_return(
        status: 510,
        body: JSON.generate({
          status_code: 510,
          status_message: "Execution Exception Occurred",
          message: "Something Went Wrong",
          is_error: true,
          errors: "Array"
        }),
        headers: {"Content-Type" => "application/json"}
      )

    error = assert_raises(Frontgo::ServerError) do
      client.create_session_for_one_time_payment_link(valid_params)
    end

    assert_match(/510/, error.message)
    assert_match(/Execution Exception Occurred/, error.message)
    assert_match(/Something Went Wrong/, error.message)
  end

  def test_create_session_raises_exception_on_server_error_502
    stub_request(:post, "https://demo-api.frontpayment.no/api/v1/connect/orders/regular/submit")
      .to_return(status: 502, body: '{"error": "Bad Gateway"}', headers: {"Content-Type" => "application/json"})

    error = assert_raises(Frontgo::ServerError) do
      client.create_session_for_one_time_payment_link(valid_params)
    end

    assert_match(/502/, error.message)
    assert_match(/Bad Gateway/, error.message)
  end

  def test_create_session_raises_exception_on_server_error_503
    stub_request(:post, "https://demo-api.frontpayment.no/api/v1/connect/orders/regular/submit")
      .to_return(status: 503, body: '{"error": "Service Unavailable"}', headers: {"Content-Type" => "application/json"})

    error = assert_raises(Frontgo::ServerError) do
      client.create_session_for_one_time_payment_link(valid_params)
    end

    assert_match(/503/, error.message)
    assert_match(/Service Unavailable/, error.message)
  end

  def test_create_session_raises_exception_on_client_error_400
    stub_request(:post, "https://demo-api.frontpayment.no/api/v1/connect/orders/regular/submit")
      .to_return(status: 400, body: '{"error": "Bad Request"}', headers: {"Content-Type" => "application/json"})

    error = assert_raises(Frontgo::ClientError) do
      client.create_session_for_one_time_payment_link(valid_params)
    end

    assert_match(/400/, error.message)
    assert_match(/Bad Request/, error.message)
  end

  def test_create_session_raises_exception_on_client_error_401
    stub_request(:post, "https://demo-api.frontpayment.no/api/v1/connect/orders/regular/submit")
      .to_return(status: 401, body: '{"error": "Unauthorized"}', headers: {"Content-Type" => "application/json"})

    error = assert_raises(Frontgo::ClientError) do
      client.create_session_for_one_time_payment_link(valid_params)
    end

    assert_match(/401/, error.message)
    assert_match(/Unauthorized/, error.message)
  end

  def test_create_session_raises_exception_on_client_error_404
    stub_request(:post, "https://demo-api.frontpayment.no/api/v1/connect/orders/regular/submit")
      .to_return(status: 404, body: '{"error": "Not Found"}', headers: {"Content-Type" => "application/json"})

    error = assert_raises(Frontgo::ClientError) do
      client.create_session_for_one_time_payment_link(valid_params)
    end

    assert_match(/404/, error.message)
    assert_match(/Not Found/, error.message)
  end

  def test_create_session_raises_exception_on_too_many_requests_error_429
    stub_request(:post, "https://demo-api.frontpayment.no/api/v1/connect/orders/regular/submit")
      .to_return(status: 429, body: '{"error": "Too Many Requests"}', headers: {"Content-Type" => "application/json"})

    error = assert_raises(Frontgo::ClientError) do
      client.create_session_for_one_time_payment_link(valid_params)
    end

    assert_match(/429/, error.message)
    assert_match(/Too Many Requests/, error.message)
  end

  def test_create_session_raises_exception_on_ssl_error
    stub_request(:post, "https://demo-api.frontpayment.no/api/v1/connect/orders/regular/submit")
      .to_raise(Faraday::SSLError.new("SSL certificate verification failed"))

    assert_raises(Faraday::SSLError) do
      client.create_session_for_one_time_payment_link(valid_params)
    end
  end

  def test_create_session_raises_exception_on_parsing_error
    stub_request(:post, "https://demo-api.frontpayment.no/api/v1/connect/orders/regular/submit")
      .to_return(status: 200, body: "invalid json response", headers: {"Content-Type" => "application/json"})

    assert_raises(Faraday::ParsingError) do
      client.create_session_for_one_time_payment_link(valid_params)
    end
  end

  private

  def client
    @client ||= Frontgo::Client.new(key: client_key, demo: true)
  end

  def client_key
    ENV["FRONTGO_API_KEY"] || "test_key"
  end

  def valid_params
    {
      products: [
        {
          name: "Test Product",
          productId: "P-1",
          quantity: "1",
          rate: 100,
          discount: 0,
          tax: 0,
          amount: 100
        }
      ],
      orderSummary: {
        subTotal: "100.00",
        totalTax: "0.00",
        totalDiscount: "0.00",
        shippingCost: "0.00",
        grandTotal: "100.00"
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
        email: "test@example.com",
        name: "Test User",
        preferredLanguage: "en",
        personalNumber: "12345678901",
        organizationId: nil,
        address: {
          street: "Test Street 1",
          zip: "1234",
          city: "Test City",
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
        callbackUrl: "https://www.example.com/callback",
        success: "https://www.example.com/success",
        failure: "https://www.example.com/failure"
      }
    }
  end
end
