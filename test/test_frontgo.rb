# frozen_string_literal: true

require "test_helper"

class TestFrontgo < Minitest::Test
  def test_create_session_for_one_time_payment_link
    VCR.use_cassette("create_session_for_one_time_payment_link") do
      response = client.create_session_for_one_time_payment_link({
          products: [
              {
                  name: "Router",
                  productId: "R_1",
                  quantity: "1",
                  rate: 4500,
                  discount: 0,
                  tax: "12",
                  amount: 4500
              }
          ],
          orderSummary: {
              subTotal: "4017.86",
              totalTax: "482.14",
              totalDiscount: "0.00",
              grandTotal: "4500.00"
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
              success: "https://www.frontpayment.no/success",
              failure: "https://www.frontpayment.no/failure"
          }
      })
    end
  end

  def test_create_session_for_invoice_order
    VCR.use_cassette("create_session_for_invoice_order") do
      response = client.create_session_for_invoice_order({
        products: [
          {
            name: "Router",
            productId: "R_1",
            quantity: "1",
            rate: 4500,
            discount: 0,
            tax: "12",
            amount: 4500
          }
        ],
        orderSummary: {
          subTotal: "4017.86",
          totalTax: "482.14",
          totalDiscount: "0.00",
          grandTotal: "4500.00"
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
          email: "karinordmann@yopmail.com",
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
          success: "https://www.frontpayment.no/success",
          failure: "https://www.frontpayment.no/failure"
        }
      })
    end
  end

  def test_get_all_order_status
    VCR.use_cassette("get_all_order_status") do
      response = client.get_all_order_status
    end
  end

  def test_get_all_order_status_with_filter
    VCR.use_cassette("get_all_order_status_with_filter") do
      response = client.get_all_order_status(type: 'paid')
    end
  end

  def test_get_order_status_by_uuid
    VCR.use_cassette("get_order_status_by_uuid") do
      response = client.get_order_status_by_uuid("ODR347888404")
    end
  end

  def test_get_order_details_by_uuid
    VCR.use_cassette("get_order_details_by_uuid") do
      response = client.get_order_details_by_uuid("ODR986760186")
    end
  end

  def test_send_e_faktura
    VCR.use_cassette("send_e_faktura") do
      response = client.send_e_faktura({
        products: {
          "0": {
            name: "Hair Wash",
            productId: "VFDDF",
            quantity: "1",
            rate: 51,
            discount: 0,
            tax: "0",
            amount: 51
          }
        },
        orderSummary: {
          subTotal: "51.00",
          totalTax: "0.00",
          totalDiscount: "0.00",
          grandTotal: "51.00"
        },
        orderDate: "5 Dec, 2023",
        dueDateForPaymentLink: "1703040812",
        sendOrderBy: {
          sms: false,
          email: false,
          invoice: true
        },
        invoiceAsPaymentOption: false,
        isCreditCheckAvailable: false,
        customerDetails: {
          type: "private",
          countryCode: "+47",
          msisdn: "46567468",
          email: "test@yopmail.com",
          customerUuid: "CSRT3672053467",
          name: "Kari Nordmann",
          preferredLanguage: "en",
          personalNumber: "12345678901",
          address: {
            street: "Luramyrveien 65",
            zip: "4313",
            city: "Sandnes",
            country: "NO"
          }
        },
        invoiceReferences: {
          referenceNo: "Dhaka",
          customerReference: "3500",
          receiptNo: "Cumilla",
          customerNotes: "NO",
          tnc: "adfsl"
        },
        internalReferences: {
          referenceNo: "Dhaka",
          notes: "3500"
        }
      })
    end
  end

  def test_send_ehf_invoice
    VCR.use_cassette("send_ehf_invoice") do
      response = client.send_ehf_invoice({
        products: {
          "0": {
            name: "Hair Wash",
            productId: "VFDDF",
            quantity: "1",
            rate: 51,
            discount: 0,
            tax: "0",
            amount: 51
          }
        },
        orderSummary: {
          subTotal: "51.00",
          totalTax: "0.00",
          totalDiscount: "0.00",
          grandTotal: "51.00"
        },
        orderDate: "5 Dec, 2023",
        customerDetails: {
          type: "corporate",
          countryCode: "+47",
          msisdn: "46567468",
          email: "kari_nordman@yopmail.com",
          name: "Kari Nordmann",
          organizationId: "123456789",
          address: {
            street: "Luramyrveien 65",
            zip: "4313",
            city: "Sandnes",
            country: "NO"
          }
        },
        invoiceReferences: {
          referenceNo: "66346334",
          customerReference: "350530",
          receiptNo: "3535353345",
          invoiceInterval: 0,
          separateInvoices: true,
          invoiceMaturity: 10
        }
      })
    end
  end

  def test_cancel_order
    VCR.use_cassette("cancel_order") do
      response = client.cancel_order("ODR123456789", {
        cancellationNote: "Test cancellation Note, Replace with real one"
      })
    end
  end

  def test_send_payment_link
    VCR.use_cassette("send_payment_link") do
      response = client.send_payment_link({
        products: {
          "0": {
            name: "Hair Wash",
            productId: "VFDDF",
            quantity: "1",
            rate: 51,
            discount: 0,
            tax: "0",
            amount: 51
          }
        },
        orderSummary: {
          subTotal: "51.00",
          totalTax: "0.00",
          totalDiscount: "0.00",
          grandTotal: "51.00"
        },
        orderDate: "5 Dec, 2023",
        dueDateForPaymentLink: "1703040812",
        sendOrderBy: {
          sms: true,
          email: false,
          invoice: false
        },
        invoiceAsPaymentOption: false,
        isCreditCheckAvailable: false,
        customerDetails: {
          type: "private",
          countryCode: "+47",
          msisdn: "46567468",
          email: "example@domain.com",
          customerUuid: "CSRT3672053467",
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
        invoiceReferences: {
          referenceNo: "Dhaka",
          customerReference: "3500",
          receiptNo: "Cumilla",
          customerNotes: "NO",
          tnc: "adfsl"
        },
        internalReferences: {
          referenceNo: "Dhaka",
          notes: "3500"
        }
      })
    end
  end

  def test_send_invoice
    VCR.use_cassette("send_invoice") do
      response = client.send_invoice({
        products: {
          "0": {
            name: "Hair Wash",
            productId: "VFDDF",
            quantity: "1",
            rate: 51,
            discount: 0,
            tax: "0",
            amount: 51
          }
        },
        orderSummary: {
          subTotal: "51.00",
          totalTax: "0.00",
          totalDiscount: "0.00",
          grandTotal: "51.00"
        },
        orderDate: "5 Dec, 2023",
        dueDateForPaymentLink: "1703040812",
        sendOrderBy: {
          sms: false,
          email: false,
          invoice: true
        },
        invoiceAsPaymentOption: false,
        isCreditCheckAvailable: false,
        customerDetails: {
          type: "private",
          countryCode: "+47",
          msisdn: "46567468",
          email: "test@yopmail.com",
          customerUuid: "CSRT3672053467",
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
        invoiceReferences: {
          referenceNo: "Dhaka",
          customerReference: "3500",
          receiptNo: "Cumilla",
          customerNotes: "NO",
          tnc: "adfsl"
        },
        invoiceInterval: 0,
        separateInvoices: true,
        internalReferences: {
          referenceNo: "Dhaka",
          notes: "3500"
        }
      })
    end
  end

  def test_resend_payment_link
    VCR.use_cassette("resend_payment_link") do
      response = client.resend_payment_link("ODR123456789", {
        countryCode: "+47",
        msisdn: "46567468",
        email: "user@gmail.com"
      })
    end
  end

  def test_refund_order
    VCR.use_cassette("refund_order") do
      response = client.refund_order("ODR123456789", {
        type: "regular",
        grandTotal: 55,
        products: [
          {
            id: 451,
            amount: 30
          },
          {
            id: 452,
            amount: 25
          }
        ],
        source: nil,
        reference: nil
      })
    end
  end

  def test_get_invoice_number_by_uuid
    VCR.use_cassette("get_invoice_number_by_uuid") do
      response = client.get_invoice_number_by_uuid("ODR2005869234")
    end
  end

  private

  def client
    @client ||= Frontgo::Client.new(
      "https://demo-api.frontpayment.no/", key: (ENV['FRONTGO_API_KEY'] || 'key')
    )
  end
end
