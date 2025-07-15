# frozen_string_literal: true

module Rails
  module Clock
    # Provides controller helper methods for accessing reference time
    module ControllerSupport
      extend ActiveSupport::Concern

      def requested_at = Rails::Clock.reference_time
    end
  end
end
