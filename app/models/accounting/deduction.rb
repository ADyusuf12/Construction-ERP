module Accounting
  class Deduction < ApplicationRecord
    # Adding touch: true ensures that when a deduction is saved,
    # the Salary's updated_at changes, which helps with cache busting.
    belongs_to :salary, class_name: "Accounting::Salary", touch: true

    enum :deduction_type, {
      tax: 0, pension: 1, loan: 2, health_insurance: 3, other: 4, recurring: 5
    }, prefix: true

    validates :deduction_type, presence: true
    validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }

    # The Link: Every time a deduction is created, updated, or destroyed,
    # we force the parent salary to re-calculate its net_pay.
    after_commit :update_salary_net_pay

    private

    def update_salary_net_pay
      salary.save # This triggers the before_validation :calculate_net_pay in the Salary model
    end
  end
end
