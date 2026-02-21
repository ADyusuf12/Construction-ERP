module Accounting
  class Salary < ApplicationRecord
    belongs_to :employee, class_name: "Hr::Employee"
    belongs_to :batch, class_name: "Accounting::SalaryBatch"
    has_many :deductions, class_name: "Accounting::Deduction", dependent: :destroy

    validates :base_pay, presence: true, numericality: { greater_than_or_equal_to: 0 }
    validates :net_pay, presence: true

    enum :status, { pending: 0, paid: 1, failed: 2 }, prefix: true

    # Calculate net pay before saving to ensure the database is always accurate
    before_validation :calculate_net_pay

    def total_deductions
      # Optimizes performance by checking if the collection is already loaded
      deductions.loaded? ? deductions.map(&:amount).sum : deductions.sum(:amount)
    end

    private

    def calculate_net_pay
      # Convert nils to zero for safe math
      bp = base_pay || 0
      al = allowances || 0
      de = total_deductions || 0

      # Update the database columns
      self.deductions_total = de
      self.net_pay = bp + al - de
    end
  end
end
