class ProjectExpense < ApplicationRecord
  belongs_to :project, optional: true
  belongs_to :stock_movement, optional: true

  validates :date, :description, :amount, presence: true
  validates :amount, numericality: { greater_than: 0 }

  scope :recent, -> { order(date: :desc) }
end
