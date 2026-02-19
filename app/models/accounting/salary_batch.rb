module Accounting
  class SalaryBatch < ApplicationRecord
    has_many :salaries, class_name: "Accounting::Salary", foreign_key: "batch_id", dependent: :destroy

    validates :name, :period_start, :period_end, presence: true
    validate :end_date_after_start_date

    enum :status, { pending: 0, processed: 1, paid: 2 }, prefix: true

    scope :recent, -> { order(period_start: :desc) }

    # The Magic Hook: Generates the payroll list automatically
    after_create :populate_salaries_from_staff_roster

    def period_label
      period_start&.strftime("%B %Y") || "N/A"
    end

    def total_net_pay
      salaries.sum(:net_pay)
    end

    def mark_all_salaries_paid!
      transaction do
        salaries.update_all(status: :paid, updated_at: Time.current)
        update!(status: :paid)
      end
    rescue StandardError => e
      Rails.logger.error "SalaryBatch Settlement Failed: #{e.message}"
      false
    end

    private

    def populate_salaries_from_staff_roster
      # Guard against multiple executions in a single request lifecycle
      return if @populated

      # Use a broad transaction to ensure data consistency
      transaction do
        Hr::Employee.status_active.where("base_salary > 0").each do |employee|
          # 1. Calculate Adjustment Totals first to avoid incremental update loops
          active_adjustments = employee.recurring_adjustments.active
          total_recurring_allowances = active_adjustments.allowance.sum(:amount)

          # 2. Create the base salary record
          current_salary = salaries.create!(
            employee: employee,
            base_pay: employee.base_salary,
            allowances: total_recurring_allowances,
            status: :pending
          )

          # 3. Create the individual Deduction line items
          active_adjustments.deduction.each do |adj|
            current_salary.deductions.create!(
              deduction_type: :recurring,
              amount: adj.amount,
              notes: "Recurring: #{adj.label}"
            )
          end

          # The Salary model's before_validation :calculate_net_pay
          # will have triggered on create! and will trigger again if
          # deductions were added because of the Deduction model's after_commit.
        end
      end

      @populated = true
    end

    def end_date_after_start_date
      return if period_end.blank? || period_start.blank?
      if period_end < period_start
        errors.add(:period_end, "must be after the start date")
      end
    end
  end
end
