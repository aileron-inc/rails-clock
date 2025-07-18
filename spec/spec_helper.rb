# frozen_string_literal: true

require "rails/clock"
require "active_support/core_ext/numeric/time"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # Reset reference time before each test
  config.before(:each) do
    Rails::Clock.reference_time = nil
  end
end
