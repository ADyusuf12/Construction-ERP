class Notification < ApplicationRecord
  belongs_to :recipient, polymorphic: true
  belongs_to :actor, polymorphic: true, optional: true
  belongs_to :notifiable, polymorphic: true

  scope :unread, -> { where(read_at: nil) }
  scope :recent, -> { order(created_at: :desc).limit(10) }

  # Real-time broadcast to the user's specific channel
  after_create_commit do
    broadcast_prepend_to "notifications_#{recipient_id}",
                         target: "notifications_list",
                         partial: "dashboard/notifications/notification",
                         locals: { notification: self }

    # Also update the unread count/red dot
    broadcast_update_to "notifications_#{recipient_id}",
                        target: "notifications_count",
                        html: recipient.notifications.unread.count
  end

  def read?
    read_at.present?
  end

  def mark_as_read!
    update(read_at: Time.current)

    if recipient.notifications.unread.count.zero?
      broadcast_update_to "notifications_#{recipient_id}",
                          target: "notifications_count",
                          html: ""
    end
  end

  def to_path
    return Rails.application.routes.url_helpers.dashboard_home_path if notifiable.nil?

    if notifiable.respond_to?(:notification_path)
      notifiable.notification_path(self)
    else
      begin
        Rails.application.routes.url_helpers.polymorphic_path(notifiable)
      rescue
        Rails.application.routes.url_helpers.dashboard_home_path
      end
    end
  end

  def message
    params&.with_indifferent_access&.dig(:message) || "System Update"
  end
end
