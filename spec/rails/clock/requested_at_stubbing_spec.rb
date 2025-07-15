# frozen_string_literal: true

RSpec.describe Rails::Clock::RequestedAtStubbing do
  let(:controller_class) do
    Class.new do
      def self.before_action(method_name)
        @before_actions ||= []
        @before_actions << method_name
      end

      include Rails::Clock::RequestedAtStubbing

      attr_accessor :request, :params
    end
  end

  let(:controller) { controller_class.new }
  let(:request) { double("request", headers: headers) }
  let(:headers) { {} }
  let(:params) { {} }

  before do
    controller.request = request
    controller.params = params
  end

  describe "#set_reference_time_from_request" do
    context "with X-REQUESTED-AT header" do
      let(:headers) { { "X-REQUESTED-AT" => "2024-01-01 12:00:00" } }

      it "sets reference time from header" do
        controller.send(:set_reference_time_from_request)
        expect(Rails::Clock.reference_time).to eq(Time.parse("2024-01-01 12:00:00"))
      end
    end

    context "with _requested_at param" do
      let(:params) { { _requested_at: "202401011200" } }

      it "sets reference time from param" do
        controller.send(:set_reference_time_from_request)
        expect(Rails::Clock.reference_time).to eq(Time.new(2024, 1, 1, 12, 0))
      end
    end

    context "with invalid time format" do
      let(:headers) { { "X-REQUESTED-AT" => "invalid" } }

      it "does not change reference time" do
        original_time = Rails::Clock.reference_time
        controller.send(:set_reference_time_from_request)
        expect(Rails::Clock.reference_time).to be_within(1.second).of(original_time)
      end
    end
  end
end
