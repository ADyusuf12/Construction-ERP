module Hr
  class Employee < ApplicationRecord
    belongs_to :user, optional: true
    delegate :email, to: :user, allow_nil: true
    belongs_to :manager, class_name: "Hr::Employee", optional: true

    has_many :subordinates, class_name: "Hr::Employee", foreign_key: "manager_id", dependent: :nullify
    has_many :leaves, class_name: "Hr::Leave", dependent: :destroy
    has_many :assignments, dependent: :destroy
    has_many :tasks, through: :assignments
    has_many :reports, class_name: "Report", dependent: :nullify
    has_one :personal_detail, class_name: "Hr::PersonalDetail", dependent: :destroy, inverse_of: :employee
    has_many :salaries, class_name: "Accounting::Salary", dependent: :destroy
    has_many :attendance_records, class_name: "Hr::AttendanceRecord",  dependent: :destroy
    has_many :next_of_kins, class_name: "Hr::NextOfKin", dependent: :destroy
    has_many :recurring_adjustments, class_name: "Hr::RecurringAdjustment", dependent: :destroy
    has_many :deductions, through: :salaries, class_name: "Accounting::Deduction"

    accepts_nested_attributes_for :personal_detail, update_only: true, allow_destroy: true
    accepts_nested_attributes_for :next_of_kins, allow_destroy: true, reject_if: :all_blank

    enum :status, { active: 0, on_leave: 1, terminated: 2 }, prefix: true

    validates :staff_id, presence: true, uniqueness: true
    validates :department, presence: true
    validates :position_title, presence: true

    validate :user_role_and_email_valid, if: -> { user.present? }

    before_validation :generate_staff_id, on: :create

    def full_name
      if personal_detail.present?
        "#{personal_detail.first_name} #{personal_detail.last_name}"
      else
        "Employee ##{staff_id}"
      end
    end

    def allowances_total
      recurring_adjustments.allowance.active.sum(:amount)
    end

    def deductions_total
      recurring_adjustments.deduction.active.sum(:amount)
    end

    private

    def generate_staff_id
      return if staff_id.present?
      return if hire_date.blank?

      year_suffix = hire_date.year.to_s[-2..]

      # Finding the highest code for the current year
      last_record = Hr::Employee.where("staff_id LIKE ?", "%#{year_suffix}").order(:staff_id).last

      if last_record.present?
        last_sequence = last_record.staff_id[0..2].to_i
        sequence = (last_sequence + 1).to_s.rjust(3, "0")
      else
        sequence = "001"
      end

      self.staff_id = "#{sequence}#{year_suffix}"
    end

    def user_role_and_email_valid
      # Added 'admin' to staff_roles so your admin user can have an employee profile
      staff_roles = %w[ceo cto qs site_manager engineer storekeeper hr accountant admin]
      unless user.role.in?(staff_roles)
        errors.add(:user, "must have a staff role")
      end

      # Dynamic domain check: falls back to example.com if ENV is not set
      allowed_domain = ENV.fetch("ALLOWED_DOMAIN", "example.com")
      unless user.email.ends_with?("@#{allowed_domain}")
        errors.add(:user, "must have a company email (@#{allowed_domain})")
      end
    end
  end
end
