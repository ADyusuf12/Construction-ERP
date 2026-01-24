class Project < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :client, class_name: "Business::Client", optional: true

  has_many :tasks, dependent: :destroy
  has_many :reports, dependent: :destroy
  has_many :assignments, through: :tasks
  has_many :project_inventories, dependent: :destroy
  has_many :inventory_items, through: :project_inventories
  has_many :project_expenses, dependent: :destroy

  # --- Files ---
  has_many :project_files, dependent: :destroy
  accepts_nested_attributes_for :project_files, allow_destroy: true

  enum :status, { ongoing: 0, completed: 1 }, prefix: true

  validates :name, presence: true, length: { maximum: 100 }
  validates :description, presence: true

  scope :due_soon, -> { where("deadline <= ?", 1.week.from_now) }
  scope :overdue, -> { where("deadline < ? AND status != ?", Time.current, statuses[:completed]) }

  # --- Task progress ---
  def progress
    return 0 if tasks.empty?

    total_weight = tasks.sum(:weight)
    completed_weight = tasks.status_done.sum(:weight)

    ((completed_weight.to_f / total_weight) * 100).round
  end

  # --- Budget calculations ---
  def total_expenses
    project_expenses.sum(:amount)
  end

  def remaining_budget
    return 0 unless budget.present?
    budget - total_expenses
  end

  def budget_consumed_percentage
    return 0 unless budget.present? && budget > 0
    ((total_expenses.to_f / budget) * 100).round
  end

  # --- Convenience ---
  def all_files
    project_files.includes(file_attachment: :blob).map(&:file)
  end
end
