# frozen_string_literal: true

module Frontgo
  # @see https://docs.frontpayment.no/books/fpgo-connect/chapter/customer-management
  module Customer
    # @example Get customer details
    #   client.get_customer_details_by_uuid("CSRT1511414842")
    def get_customer_details_by_uuid(uuid)
      get "api/v1/connect/customers/details/#{uuid}"
    end

    # @example Update private customer
    #   client.update_private_customer("CSRT1511414842", {
    #     name: "Kari Nordmann",
    #     countryCode: "+47",
    #     msisdn: "46567468",
    #     email: "kari@example.com",
    #     preferredLanguage: "en",
    #     personalNumber: "12345678901",
    #     addresses: {
    #       billing: {
    #         street: "Luramyrveien 65",
    #         zip: "4313",
    #         city: "Sandnes",
    #         country: "NO"
    #       },
    #       shipping: {
    #         street: "Sjøhusbakken 42",
    #         zip: "4313",
    #         city: "Stavanger",
    #         country: "NO"
    #       }
    #     }
    #   })
    def update_private_customer(uuid, params)
      put "api/v1/connect/customers/update/private/#{uuid}", params
    end

    # @example Update corporate customer
    #   client.update_corporate_customer("CSRT1511414842", {
    #     name: "Acme Corporation",
    #     organizationId: "192933933",
    #     countryCode: "+47",
    #     msisdn: "46567468",
    #     email: "contact@acme.com",
    #     preferredLanguage: "en",
    #     addresses: {
    #       billing: {
    #         street: "Luramyrveien 65",
    #         zip: "4313",
    #         city: "Sandnes",
    #         country: "NO"
    #       },
    #       shipping: {
    #         street: "Sjøhusbakken 42",
    #         zip: "4313",
    #         city: "Oslo",
    #         country: "NO"
    #       }
    #     },
    #     additionalContact: {
    #       "0": {
    #         name: "John Doe",
    #         email: "john@acme.com",
    #         designation: "CEO",
    #         countryCode: "+47",
    #         msisdn: "12345678",
    #         note: "Primary contact"
    #       }
    #     }
    #   })
    def update_corporate_customer(uuid, params)
      put "api/v1/connect/customers/update/corporate/#{uuid}", params
    end
  end
end
