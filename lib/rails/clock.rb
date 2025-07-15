# frozen_string_literal: true

require "active_support"
require "active_support/core_ext/module/attribute_accessors_per_thread"
require "active_support/core_ext/time"
require_relative "clock/version"
require_relative "clock/controller_support"
require_relative "clock/model_support"
require_relative "clock/requested_at_stubbing"

module Rails
  # Provides time control functionality for Rails applications
  module Clock
    class Error < StandardError; end

    thread_mattr_accessor :reference_time_value

    class << self
      def reference_time = reference_time_value || Time.current

      def reference_time=(time)
        self.reference_time_value = time
      end

      def with(time)
        old_time = reference_time_value
        self.reference_time_value = time
        yield
      ensure
        self.reference_time_value = old_time
      end

      def present?
        !reference_time_value.nil?
      end

      def blank?
        reference_time_value.nil?
      end

      def clear
        self.reference_time_value = nil
      end

      def explicit_time
        reference_time_value
      end
    end
  end
end
