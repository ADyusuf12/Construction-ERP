require 'rails_helper'

RSpec.describe Notification, type: :model do
  describe "associations" do
    it { should belong_to(:recipient) }
    it { should belong_to(:notifiable) }
    it { should belong_to(:actor).optional }
  end

  describe "scopes" do
    let!(:unread_notification) { create(:notification, read_at: nil) }
    let!(:read_notification) { create(:notification, :read) }

    it "returns unread notifications" do
      expect(Notification.unread).to include(unread_notification)
      expect(Notification.unread).not_to include(read_notification)
    end
  end

  describe "#read?" do
    it "returns true if read_at is present" do
      notification = build(:notification, read_at: Time.current)
      expect(notification.read?).to be true
    end

    it "returns false if read_at is nil" do
      notification = build(:notification, read_at: nil)
      expect(notification.read?).to be false
    end
  end

  describe "#mark_as_read!" do
    let(:notification) { create(:notification) }

    it "updates the read_at timestamp" do
      expect { notification.mark_as_read! }.to change { notification.read_at }.from(nil)
    end
  end

  describe "#message" do
    it "returns the message from params" do
      notification = build(:notification, params: { message: "Custom Alert" })
      expect(notification.message).to eq("Custom Alert")
    end

    it "returns a fallback message if params is empty" do
      notification = build(:notification, params: nil)
      expect(notification.message).to eq("System Update")
    end
  end

  describe "#to_path" do
    let(:user) { create(:user) }

    context "when notifiable responds to notification_path" do
      it "calls notification_path on the notifiable" do
        task = create(:task)
        notification = create(:notification, notifiable: task)

        # We check if it contains the anchor logic we wrote in the Task model
        expect(notification.to_path).to include("#task_#{task.id}")
      end
    end

    context "when notifiable is nil" do
      it "returns the root path" do
        notification = build_stubbed(:notification, notifiable: nil)
        expect(notification.to_path).to eq(Rails.application.routes.url_helpers.dashboard_home_path)
      end
    end
  end
end
