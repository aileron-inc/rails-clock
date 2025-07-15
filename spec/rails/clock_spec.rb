# frozen_string_literal: true

RSpec.describe Rails::Clock do
  it "has a version number" do
    expect(Rails::Clock::VERSION).not_to be nil
  end

  describe ".reference_time" do
    it "returns current time by default" do
      expect(Rails::Clock.reference_time).to be_within(1.second).of(Time.current)
    end

    it "returns set time when set" do
      time = Time.new(2024, 1, 1, 12, 0, 0)
      Rails::Clock.reference_time = time
      expect(Rails::Clock.reference_time).to eq(time)
    end
  end

  describe ".with" do
    it "temporarily sets reference time within block" do
      original_time = Time.new(2024, 1, 1, 10, 0, 0)
      temp_time = Time.new(2024, 1, 1, 15, 0, 0)
      Rails::Clock.reference_time = original_time

      Rails::Clock.with(temp_time) do
        expect(Rails::Clock.reference_time).to eq(temp_time)
      end

      expect(Rails::Clock.reference_time).to eq(original_time)
    end

    it "restores original time even if exception occurs" do
      original_time = Time.new(2024, 1, 1, 10, 0, 0)
      temp_time = Time.new(2024, 1, 1, 15, 0, 0)
      Rails::Clock.reference_time = original_time

      expect do
        Rails::Clock.with(temp_time) do
          raise "Test exception"
        end
      end.to raise_error("Test exception")

      expect(Rails::Clock.reference_time).to eq(original_time)
    end
  end

  describe ".present? and .blank?" do
    it "returns false/true when reference time is not set" do
      Rails::Clock.clear
      expect(Rails::Clock.present?).to be false
      expect(Rails::Clock.blank?).to be true
    end

    it "returns true/false when reference time is set" do
      Rails::Clock.reference_time = Time.new(2024, 1, 1, 12, 0, 0)
      expect(Rails::Clock.present?).to be true
      expect(Rails::Clock.blank?).to be false
    end
  end

  describe ".clear" do
    it "resets reference time to nil" do
      Rails::Clock.reference_time = Time.new(2024, 1, 1, 12, 0, 0)
      expect(Rails::Clock.present?).to be true

      Rails::Clock.clear
      expect(Rails::Clock.blank?).to be true
      expect(Rails::Clock.reference_time).to be_within(1.second).of(Time.current)
    end
  end

  describe ".explicit_time" do
    it "returns nil when reference time is not set" do
      Rails::Clock.clear
      expect(Rails::Clock.explicit_time).to be_nil
    end

    it "returns the explicitly set time" do
      time = Time.new(2024, 1, 1, 12, 0, 0)
      Rails::Clock.reference_time = time
      expect(Rails::Clock.explicit_time).to eq(time)
    end

    it "differs from reference_time when not set" do
      Rails::Clock.clear
      expect(Rails::Clock.explicit_time).to be_nil
      expect(Rails::Clock.reference_time).not_to be_nil
    end
  end
end
