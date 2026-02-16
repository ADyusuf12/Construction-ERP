module Hr
  class Leave < ApplicationRecord
    belongs_to :employee, class_name: "Hr::Employee"
    belongs_to :manager, class_name: "Hr::Employee", optional: true

    enum :status, { pending: 0, approved: 1, rejected: 2, cancelled: 3 }, prefix: true

    validates :start_date, :end_date, :reason, presence: true
    validate :end_date_after_start_date
    validate :has_sufficient_balance, on: :create

    # Number of days requested
    def duration
      return 0 if start_date.blank? || end_date.blank?
      (end_date - start_date).to_i + 1
    end

    private

    def has_sufficient_balance
      return if employee.blank? || start_date.blank? || end_date.blank?

      if employee.leave_balance < duration
        errors.add(:base, "Requested duration (#{duration} days) exceeds your current balance of #{employee.leave_balance} days.")
      end
    end

    def end_date_after_start_date
      return if end_date.blank? || start_date.blank?
      errors.add(:end_date, "must be after start date") if end_date < start_date
    end
  end
end
