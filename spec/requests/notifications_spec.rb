require 'rails_helper'

RSpec.describe "Notifications", type: :request do
  let(:user) { create(:user) }
  let(:task) { create(:task) }
  let(:notification) { create(:notification, recipient: user, notifiable: task) }

  before { sign_in user }

  describe "GET /index" do
    it "renders the notification archive successfully" do
      get notifications_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include("Notification Archive")
    end
  end

  describe "PATCH /update" do
    context "when clicking the notification (redirection flow)" do
      it "marks the notification as read and redirects to the notifiable path" do
        patch notification_path(notification)

        expect(notification.reload.read?).to be true
        expect(response).to redirect_to(notification.to_path)
        expect(response).to have_http_status(:see_other)
      end
    end

    context "when clearing the notification (read_only flow)" do
      it "marks as read and responds with turbo_stream" do
        patch notification_path(notification, params: { read_only: true }, format: :turbo_stream)

        expect(notification.reload.read?).to be true
        expect(response.media_type).to eq("text/vnd.turbo-stream.html")
        expect(response.body).to include("turbo-stream action=\"replace\"")
      end
    end

    context "security" do
      it "does not allow updating another user's notification" do
        other_user = create(:user)
        other_notification = create(:notification, recipient: other_user)

        patch notification_path(other_notification)

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "POST /mark_all_as_read" do
    before { create_list(:notification, 3, recipient: user) }

    it "sets read_at for all unread notifications of the user" do
      post mark_all_as_read_notifications_path

      expect(user.notifications.unread.count).to eq(0)
    end

    it "updates the notifications_count using a partial" do
      patch notification_path(notification, params: { read_only: true }, format: :turbo_stream)
      expect(response.body).to include("turbo-stream action=\"update\" target=\"notifications_count\"")
      # You can check if it rendered the pulse class from the partial
      expect(response.body).to include("animate-ping")
    end
  end
end
