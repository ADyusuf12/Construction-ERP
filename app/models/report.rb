class Report < ApplicationRecord
  belongs_to :project
  belongs_to :employee, class_name: "Hr::Employee"

  enum :report_type, { daily: 0, weekly: 1 }, prefix: true
  enum :status, { draft: 0, submitted: 1, reviewed: 2 }, prefix: true

  validates :report_date, presence: true
  validates :progress_summary, presence: true, length: { minimum: 10 }

  after_update :notify_status_change, if: :saved_change_to_status?

  # Delegate name for easier access in views
  delegate :full_name, to: :employee, prefix: true, allow_nil: true

  def notification_path(notification)
    Rails.application.routes.url_helpers.project_report_path(project, self)
  end

  private

  def notify_status_change
    if status_submitted?
      notify_oversight_of_submission
    elsif status_reviewed?
      notify_author_of_review
    end
  end

  def notify_oversight_of_submission
    target_roles = [ :ceo, :admin, :hr, :site_manager ]
    recipients = User.where(role: target_roles)

    recipients.each do |recipient|
      next if recipient == employee.user

      recipient.notify(
        action: "report_submitted",
        notifiable: self,
        actor: employee.user,
        message: "#{employee_full_name} has submitted a #{report_type} report for #{project.name}"
      )
    end
  end

  def notify_author_of_review
    return unless employee.user

    employee.user.notify(
      action: "report_reviewed",
      notifiable: self,
      actor: nil,
      message: "Your #{report_type} report for #{project.name} has been reviewed."
    )
  end
end
