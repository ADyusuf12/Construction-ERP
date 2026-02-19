module Hr
  class RecurringAdjustment < ApplicationRecord
    belongs_to :employee, class_name: "Hr::Employee"

    enum :adjustment_type, { deduction: 0, allowance: 1 }

    validates :label, :amount, presence: true
    validates :amount, numericality: { greater_than: 0 }

    scope :active, -> { where(active: true) }
  end
end
