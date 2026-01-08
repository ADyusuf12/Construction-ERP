module Accounting
  class Salary < ApplicationRecord
    belongs_to :employee, class_name: "Hr::Employee"
    belongs_to :batch, class_name: "Accounting::SalaryBatch"
    has_many :deductions, class_name: "Accounting::Deduction", dependent: :destroy

    validates :base_pay, presence: true
    validates :net_pay, presence: true

    enum :status, { pending: 0, paid: 1, failed: 2 }, prefix: true

    before_validation :calculate_net_pay

    def total_deductions
      deductions.sum(:amount)
    end

    private

    def calculate_net_pay
      self.net_pay = (base_pay || 0) + (allowances || 0) - total_deductions
    end
  end
end
