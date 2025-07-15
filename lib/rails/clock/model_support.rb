# frozen_string_literal: true

module Rails
  module Clock
    # Provides model helper methods for accessing reference time
    module ModelSupport
      extend ActiveSupport::Concern

      def reference_time = Rails::Clock.reference_time
    end
  end
end
