module Accounting
  class Deduction < ApplicationRecord
    belongs_to :salary, class_name: "Accounting::Salary"

    enum :deduction_type, {
      tax: 0,
      pension: 1,
      loan: 2,
      health_insurance: 3,
      other: 4
    }, prefix: true

    validates :deduction_type, presence: true
    validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  end
end
