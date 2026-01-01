class Project < ApplicationRecord
  belongs_to :user, optional: true
  has_many :tasks, dependent: :destroy
  has_many :accounting_transactions,
           class_name: "Accounting::Transaction",
           dependent: :destroy
  has_many :reports, dependent: :destroy

  enum :status, { ongoing: 0, completed: 1 }, prefix: true

  validates :name, presence: true, length: { maximum: 100 }
  validates :description, presence: true
  validates :progress, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }

  scope :due_soon, -> { where("deadline <= ?", 1.week.from_now) }
  scope :overdue, -> { where("deadline < ? AND status != ?", Time.current, statuses[:completed]) }

  # --- Task progress ---
  def progress
    return 0 if tasks.empty?

    total_weight = tasks.sum(:weight)
    completed_weight = tasks.status_done.sum(:weight)

    ((completed_weight.to_f / total_weight) * 100).round
  end

  # --- Transaction summaries ---
  def invoice_count
    accounting_transactions.invoice.count
  end

  def receipt_count
    accounting_transactions.receipt.count
  end

  def outstanding
    accounting_transactions.invoice.unpaid.count
  end

  # --- Budget calculations ---
  def total_expenses
    accounting_transactions.sum(:amount)
  end

  def remaining_budget
    return 0 unless budget.present?
    budget - total_expenses
  end

  def budget_consumed_percentage
    return 0 unless budget.present? && budget > 0
    ((total_expenses.to_f / budget) * 100).round
  end
end
