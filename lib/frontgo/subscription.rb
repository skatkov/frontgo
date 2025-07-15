# frozen_string_literal: true

module Frontgo
  # @see https://docs.frontpayment.no/books/fpgo-connect/chapter/subscription-management
  module Subscription
    # Create a new subscription and get payment link in response
    #
    # @param params [Hash] The subscription parameters
    # @option params [Hash] :products Product details with name, productId, quantity, rate, discount, tax, amount
    # @option params [String] :billingFrequency Billing frequency (monthly, weekly, daily)
    # @option params [Integer] :numberOfRepeats Number of billing cycles
    # @option params [Hash] :orderSummary Order summary with subTotal, totalTax, totalDiscount, grandTotal, initialCycleAmount, payablePerCycle
    # @option params [String] :subscriptionStartDate Start date of subscription
    # @option params [String] :subscriptionEndsDate End date of subscription
    # @option params [String] :dueDateForPaymentLink Due date for payment link
    # @option params [Hash] :sendOrderBy Send order by SMS and/or email
    # @option params [Hash] :customerDetails Customer information including type, contact details, and address
    # @option params [String] :customerNotes Optional customer notes
    # @option params [String] :termsAndConditions Optional terms and conditions
    # @option params [Hash] :submitPayment Payment submission details with currency
    #
    # @return [Hash] Response with subscriptionUuid, orderUuid, customerUuid, and checkoutUrl
    #
    # @note Endpoint: POST /api/v1/connect/subscription/submit
    # @note Authentication: Bearer token required
    # @note After successful response, redirect to the given payment link
    #
    # @example Create a new subscription
    #   client.create_subscription({
    #     products: { "0": { name: "Monthly Service", rate: 2000, tax: 0, amount: 2000 } },
    #     billingFrequency: "month",
    #     numberOfRepeats: 12,
    #     customerDetails: { name: "John Doe", email: "john@example.com" }
    #   })
    def create_subscription(params)
      post "api/v1/connect/subscription/submit", params
    end

    # Create a new subscription session for checkout modality
    #
    # @param params [Hash] The subscription session parameters
    # @option params [Hash] :products Product details with name, productId, quantity, rate, discount, tax, amount
    # @option params [String] :billingFrequency Billing frequency (monthly, weekly, daily)
    # @option params [Integer] :numberOfRepeats Number of billing cycles
    # @option params [Hash] :orderSummary Order summary with subTotal, totalTax, totalDiscount, grandTotal, payablePerCycle
    # @option params [String] :subscriptionStartDate Start date of subscription
    # @option params [String] :subscriptionEndsDate End date of subscription
    # @option params [String] :dueDateForPaymentLink Due date for payment link
    # @option params [Hash] :customerDetails Customer information including type, contact details, and address
    # @option params [String] :customerNotes Optional customer notes
    # @option params [String] :termsAndConditions Optional terms and conditions
    # @option params [Hash] :submitPayment Payment details with currency and via (payment method)
    # @option params [Hash] :callback Success and failure callback URLs
    # @option params [Hash] :settings Optional settings like secureDetails
    #
    # @return [Hash] Response with subscriptionUuid, orderUuid, customerUuid, and paymentUrl
    #
    # @note Endpoint: POST /api/v1/connect/subscription/create
    # @note Authentication: Bearer token required
    # @note After successful response, redirect to the given payment link
    #
    # @example Create subscription session for checkout
    #   client.create_session_for_subscription_payment({
    #     products: { "0": { name: "Premium Plan", rate: 1500, tax: 0, amount: 1500 } },
    #     billingFrequency: "month",
    #     submitPayment: { via: "visa" },
    #     callback: { success: "https://example.com/success", failure: "https://example.com/failure" }
    #   })
    def create_session_for_subscription_payment(params)
      post "api/v1/connect/subscription/create", params
    end

    # Retrieve a paginated list of subscriptions with optional filtering
    #
    # @param status [String, nil] Filter subscriptions by status (SENT, ONGOING, COMPLETED, CANCELLED)
    # @param params [Hash] Query parameters for filtering and pagination
    # @option params [Integer] :page Page number for pagination (default: 1)
    # @option params [String] :phone Filter subscriptions by phone number
    # @option params [String] :customerName Filter by customer name
    # @option params [String] :startDate Filter subscriptions that started on or after this date (YYYY-MM-DD)
    # @option params [String] :endDate Filter subscriptions that ended on or before this date (YYYY-MM-DD)
    #
    # @return [Hash] Response with data array containing subscription details and metadata for pagination
    #
    # @note Endpoint: GET /api/v1/connect/subscriptions/list/{status?}
    # @note Authentication: Bearer token required
    # @note Response includes subscriptionUuid, orderUuid, repeats, frequency, amount, currency, createdAt, customerName, etc.
    # @note Includes pagination metadata: total, perPage, currentPage, lastPage
    #
    # @example Get all subscriptions
    #   client.get_subscription_list
    # @example Get ongoing subscriptions with pagination
    #   client.get_subscription_list('ongoing', { page: 2, customerName: 'John' })
    # @example Filter by phone and date range
    #   client.get_subscription_list(nil, { phone: '+47123456789', startDate: '2023-01-01', endDate: '2023-12-31' })
    def get_subscription_list(status = nil, params = {})
      endpoint = status ? "api/v1/connect/subscriptions/list/#{status}" : "api/v1/connect/subscriptions/list"
      get endpoint, params
    end

    # Retrieve a paginated list of failed subscription orders with optional filtering
    #
    # @param status [String, nil] Filter failed payments by status (paid, invoiced, debtCollection)
    # @param params [Hash] Query parameters for filtering and pagination
    # @option params [Integer] :page Page number for pagination (default: 1)
    # @option params [String] :subscriptionUuid Filter by specific subscription UUID
    # @option params [String] :phone Filter by customer phone number
    # @option params [String] :customerName Filter by customer name
    # @option params [String] :startDate Filter orders that started on or after this date (YYYY-MM-DD)
    # @option params [String] :endDate Filter orders that ended on or before this date (YYYY-MM-DD)
    #
    # @return [Hash] Response with data array containing failed payment details and metadata for pagination
    #
    # @note Endpoint: GET /api/v1/connect/subscriptions/failed/list/{status?}
    # @note Authentication: Bearer token required
    # @note Response includes orderUuid, orderDate, customerName, countryCode, msisdn, currency, amount, status, etc.
    # @note Includes pagination metadata: total, perPage, currentPage, lastPage
    #
    # @example Get all failed payments
    #   client.get_failed_payment_list
    # @example Get invoiced failed payments with pagination
    #   client.get_failed_payment_list('invoiced', { page: 1, phone: '+47123456789' })
    # @example Filter by subscription UUID
    #   client.get_failed_payment_list(nil, { subscriptionUuid: 'SUB123456789' })
    def get_failed_payment_list(status = nil, params = {})
      endpoint = status ? "api/v1/connect/subscriptions/failed/list/#{status}" : "api/v1/connect/subscriptions/failed/list"
      get endpoint, params
    end

    # Retrieve detailed information about a specific subscription
    #
    # @param uuid [String] The subscription UUID (required)
    #
    # @return [Hash] Response with comprehensive subscription details including:
    #   - subscriptionUuid, status, subscriptionSummary
    #   - productList with product details
    #   - customerDetails and organizationDetails
    #   - subscriptionCycles with cycle-specific information
    #   - customerNote and termsAndConditions
    #
    # @note Endpoint: GET /api/v1/connect/subscriptions/details/{subscriptionUuid}
    # @note Authentication: Bearer token required
    # @note Response includes detailed subscription summary, payment history, and cycle information
    #
    # @example Get subscription details
    #   client.get_subscription_details_by_uuid('SUB123456789')
    def get_subscription_details_by_uuid(uuid)
      get "api/v1/connect/subscriptions/details/#{uuid}"
    end

    # Retrieve detailed information about a failed subscription order
    #
    # @param order_uuid [String] The order UUID of the failed payment (required)
    #
    # @return [Hash] Response with failed payment details including:
    #   - subscriptionUuid, orderDate, customerNotes
    #   - Customer information (name, contact details, address)
    #   - Order totals (subTotal, totalDiscount, totalTax, currency)
    #   - Products array with product details
    #   - Invoice and payment status
    #
    # @note Endpoint: GET /api/v1/connect/subscriptions/failed/details/{orderUuid}
    # @note Authentication: Bearer token required
    # @note Response includes comprehensive details about the failed subscription payment
    #
    # @example Get failed payment details
    #   client.get_failed_payment_details('ODR123456789')
    def get_failed_payment_details(order_uuid)
      get "api/v1/connect/subscriptions/failed/details/#{order_uuid}"
    end

    # Resend subscription payment link to customer
    #
    # @param uuid [String] The subscription UUID (required)
    # @param params [Hash] Contact information for resending
    # @option params [String] :orderUuid The order UUID
    # @option params [String] :countryCode Customer's country code
    # @option params [String] :msisdn Customer's phone number
    # @option params [String] :email Customer's email address
    #
    # @return [Hash] Response confirming successful resend
    #
    # @note Endpoint: POST /api/v1/connect/subscriptions/resend/{subscriptionUuid}
    # @note Authentication: Bearer token required
    # @note Resends the payment link to the customer via provided contact methods
    #
    # @example Resend subscription payment link
    #   client.resend_subscription('SUB123456789', {
    #     orderUuid: 'ODR123456789',
    #     countryCode: '+47',
    #     msisdn: '46567468',
    #     email: 'customer@example.com'
    #   })
    def resend_subscription(uuid, params)
      post "api/v1/connect/subscriptions/resend/#{uuid}", params
    end

    # Cancel a subscription by UUID
    #
    # @param uuid [String] The subscription UUID (required)
    # @param params [Hash] Cancellation parameters
    # @option params [String] :note Cancellation note (required)
    #
    # @return [Hash] Response confirming successful cancellation
    #
    # @note Endpoint: POST /api/v1/connect/subscriptions/cancel/{subscriptionUuid}
    # @note Authentication: Bearer token required
    # @note Only SENT and ONGOING subscriptions can be cancelled
    # @note Returns error if subscription cannot be cancelled
    #
    # @example Cancel subscription
    #   client.cancel_subscription('SUB123456789', { note: 'Customer requested cancellation' })
    def cancel_subscription(uuid, params)
      post "api/v1/connect/subscriptions/cancel/#{uuid}", params
    end

    # Refund specific cycles of a subscription
    #
    # @param uuid [String] The subscription UUID (required)
    # @param params [Hash] Refund parameters
    # @option params [Array<String>] :cycles Array of cycle names to refund (required)
    # @option params [Float] :amount Total refund amount (required)
    #
    # @return [Hash] Response confirming successful refund processing
    #
    # @note Endpoint: POST /api/v1/connect/subscriptions/cycles/refund/{subscriptionUuid}
    # @note Authentication: Bearer token required
    # @note Refunds specific order or cycle of a subscription
    # @note Returns errors if cycles not found or validation fails
    #
    # @example Refund specific subscription cycles
    #   client.refund_subscription_cycle('SUB123456789', {
    #     cycles: ['Cycle 1', 'Cycle 2'],
    #     amount: 200.00
    #   })
    def refund_subscription_cycle(uuid, params)
      post "api/v1/connect/subscriptions/cycles/refund/#{uuid}", params
    end
  end
end
