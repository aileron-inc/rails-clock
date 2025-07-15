# frozen_string_literal: true

RSpec.describe Rails::Clock::ModelSupport do
  let(:model_class) do
    Class.new do
      include Rails::Clock::ModelSupport

      attr_accessor :expires_at

      def expired?
        expires_at < reference_time
      end
    end
  end

  let(:model) { model_class.new }

  describe "#reference_time" do
    it "returns Rails::Clock.reference_time" do
      time = Time.new(2024, 1, 1, 12, 0, 0)
      Rails::Clock.reference_time = time

      expect(model.reference_time).to eq(time)
    end
  end

  describe "usage in model logic" do
    it "can be used for time-based comparisons" do
      Rails::Clock.reference_time = Time.new(2024, 1, 15, 12, 0, 0)

      model.expires_at = Time.new(2024, 1, 10, 12, 0, 0)
      expect(model.expired?).to be true

      model.expires_at = Time.new(2024, 1, 20, 12, 0, 0)
      expect(model.expired?).to be false
    end
  end
end
