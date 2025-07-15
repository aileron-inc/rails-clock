# frozen_string_literal: true

module Rails
  module Clock
    # Provides request-based time stubbing for controllers
    module RequestedAtStubbing
      extend ActiveSupport::Concern

      included do
        before_action :set_reference_time_from_request
      end

      private

      def set_reference_time_from_request
        time = parse_requested_at_from_header || parse_requested_at_from_params
        Rails::Clock.reference_time = time if time
      end

      def parse_requested_at_from_header
        Time.parse(request.headers["X-REQUESTED-AT"]) if request.headers["X-REQUESTED-AT"]
      rescue ArgumentError
        nil
      end

      def parse_requested_at_from_params
        Time.strptime(params[:_requested_at], "%Y%m%d%H%M") if params[:_requested_at]
      rescue ArgumentError
        nil
      end
    end
  end
end
