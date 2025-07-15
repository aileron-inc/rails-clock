# frozen_string_literal: true

RSpec.describe Rails::Clock::ControllerSupport do
  let(:controller_class) do
    Class.new do
      include Rails::Clock::ControllerSupport
    end
  end

  let(:controller) { controller_class.new }

  describe "#requested_at" do
    it "returns Rails::Clock.reference_time" do
      time = Time.new(2024, 1, 1, 12, 0, 0)
      Rails::Clock.reference_time = time

      expect(controller.requested_at).to eq(time)
    end

    it "changes when reference_time changes" do
      time1 = Time.new(2024, 1, 1, 12, 0, 0)
      time2 = Time.new(2024, 1, 2, 12, 0, 0)

      Rails::Clock.reference_time = time1
      expect(controller.requested_at).to eq(time1)

      Rails::Clock.reference_time = time2
      expect(controller.requested_at).to eq(time2)
    end
  end
end
