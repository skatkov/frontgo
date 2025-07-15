# frozen_string_literal: true

module Frontgo
  # @see https://docs.frontpayment.no/books/fpgo-connect/chapter/credit-check
  module Credit
    # @example Credit check for private customer
    #   client.credit_check_private({
    #     personalId: "ckFXQWJqeFlieE06ZDU3NGJlNTczMGYx",
    #     countryCode: "+47",
    #     msisdn: "46567468"
    #   })
    # @example Credit check for private customer with minimal data
    #   client.credit_check_private({
    #     personalId: "ckFXQWJqeFlieE06ZDU3NGJlNTczMGYx"
    #   })
    def credit_check_private(params)
      post "api/v1/connect/credit/check/private", params
    end

    # @example Credit check for corporate customer
    #   client.credit_check_corporate({
    #     organizationId: "998379342"
    #   })
    def credit_check_corporate(params)
      post "api/v1/connect/credit/check/corporate", params
    end

    # @example Get credit check history list
    #   client.get_credit_check_list
    def get_credit_check_list
      get "api/v1/connect/credit/check/list"
    end
  end
end