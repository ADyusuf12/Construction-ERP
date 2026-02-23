class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @notifications = current_user.notifications.order(created_at: :desc).page(params[:page]).per(10)
    render "dashboard/notifications/index"
  end

  def update
    @notification = current_user.notifications.find(params[:id])
    @notification.mark_as_read!

    if params[:read_only]
      respond_to do |format|
        format.turbo_stream {
          render turbo_stream: [
            turbo_stream.replace(@notification, partial: "dashboard/notifications/notification", locals: { notification: @notification }),
            turbo_stream.update("notifications_count", partial: "dashboard/notifications/unread_dot")
          ]
        }
        format.html { redirect_back fallback_location: root_path }
      end
    else
      # Case: User clicked the notification to go to the source (Leave, Item, etc)
      destination = @notification.to_path
      respond_to do |format|
        format.turbo_stream { redirect_to destination, status: :see_other }
        format.html { redirect_to destination, status: :see_other }
      end
    end
  end

  def mark_all_as_read
    current_user.notifications.unread.update_all(read_at: Time.current)

    respond_to do |format|
      format.turbo_stream {
        render turbo_stream: [
          turbo_stream.update("notifications_count", html: ""),
          turbo_stream.replace("notifications_list", partial: "dashboard/notifications/empty_state")
        ]
      }
      format.html { redirect_back fallback_location: dashboard_home_path }
    end
  end
end
