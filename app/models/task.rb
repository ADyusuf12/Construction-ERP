class Task < ApplicationRecord
  belongs_to :project
  has_many :assignments, dependent: :destroy
  has_many :employees, through: :assignments
  has_many :project_inventories, dependent: :destroy
  has_many :inventory_items, through: :project_inventories

  enum :status, { pending: 0, in_progress: 1, done: 2 }, prefix: true

  validates :title, presence: true, length: { maximum: 100 }
  validates :weight, numericality: { greater_than: 0 }

  after_update :notify_of_completion, if: :saved_change_to_status?

  def notification_path(notification)
    Rails.application.routes.url_helpers.project_path(project, anchor: "task_#{id}")
  end

  def notify_assigned_employees(actor)
    employees.each do |employee|
      next unless employee.user
      next if employee.user == actor

      employee.user.notify(
        action: "task_assigned",
        notifiable: self,
        actor: actor,
        message: "New Task: '#{title}' assigned to you in Project: #{project.name}"
      )
    end
  end

  private

  # --- Upstream: Completion Notifications ---
  def notify_of_completion
    return unless status_done?

    target_roles = [ :ceo, :admin, :site_manager, :qs ]
    recipients = User.where(role: target_roles)

    recipients.each do |recipient|
      next if employees.pluck(:user_id).include?(recipient.id)

      recipient.notify(
        action: "task_completed",
        notifiable: self,
        message: "Task Completed: '#{title}' (Project: #{project.name})"
      )
    end
  end
end
