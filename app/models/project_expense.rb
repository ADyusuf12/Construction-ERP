class ProjectExpense < ApplicationRecord
  belongs_to :project, optional: true
  belongs_to :stock_movement, optional: true

  validates :date, :description, :amount, presence: true
  validates :amount, numericality: { greater_than_or_equal_to: 0 }

  scope :recent, -> { order(date: :desc) }
  scope :active, -> { where("amount > 0") }

  def cancelled?
    amount.zero?
  end

  def cancel!(reason: nil)
    update!(
      description: "#{description} (Cancelled#{": #{reason}" if reason})",
      amount: 0
    )
  end
end
