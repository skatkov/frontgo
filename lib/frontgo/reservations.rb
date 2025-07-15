# frozen_string_literal: true

module Frontgo
  # @see https://docs.frontpayment.no/books/fpgo-connect/chapter/reservation-management
  module Reservations
    def submit_reservation(params)
      post "api/v1/connect/reservations/submit", params
    end

    def get_reservation_details_by_uuid(uuid)
      get "api/v1/connect/reservations/details/#{uuid}"
    end

    def cancel_reservation(uuid, params)
      post "api/v1/connect/reservations/cancel/#{uuid}", params
    end

    def capture_reservation(uuid, params)
      post "api/v1/connect/reservations/capture/#{uuid}", params
    end

    def charge_reservation(uuid, params)
      post "api/v1/connect/reservations/charge/#{uuid}", params
    end

    def complete_reservation(uuid, params)
      post "api/v1/connect/reservations/complete/#{uuid}", params
    end

    def resend_reservation(uuid, params)
      post "api/v1/connect/reservations/resend/#{uuid}", params
    end

    def refund_reservation(uuid, params)
      post "api/v1/connect/reservations/refund/#{uuid}", params
    end

    def create_session_for_reservation(params)
      post "api/v1/connect/reservations/create", params
    end

    def get_reservation_history_by_time_frame(start_timestamp, end_timestamp)
      get "api/v1/connect/reservations/history/#{start_timestamp}/#{end_timestamp}"
    end
  end
end
