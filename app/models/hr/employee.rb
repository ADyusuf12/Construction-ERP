module Hr
  class Employee < ApplicationRecord
    belongs_to :user, optional: true

    belongs_to :manager, class_name: "Hr::Employee", optional: true
    has_many :subordinates, class_name: "Hr::Employee", foreign_key: "manager_id", dependent: :nullify
    has_many :leaves, class_name: "Hr::Leave", foreign_key: "employee_id", dependent: :destroy
    has_many :leave_approvals, class_name: "Hr::Leave", foreign_key: "manager_id", dependent: :nullify
    has_one :personal_detail, class_name: "Hr::PersonalDetail", dependent: :destroy, inverse_of: :employee
    has_many :salaries, class_name: "Accounting::Salary", foreign_key: "employee_id", dependent: :destroy
    has_many :attendance_records, class_name: "Hr::AttendanceRecord", foreign_key: "employee_id", dependent: :destroy
    has_many :next_of_kins, class_name: "Hr::NextOfKin", foreign_key: "employee_id", dependent: :destroy

    accepts_nested_attributes_for :personal_detail, update_only: true, allow_destroy: true
    validates_associated :personal_detail

    enum :status, { active: 0, on_leave: 1, terminated: 2 }, prefix: true

    validates :hamzis_id, presence: true, uniqueness: true
    validates :department, presence: true
    validates :position_title, presence: true

    validate :user_role_and_email_valid, if: -> { user.present? }

    before_validation :generate_hamzis_id, on: :create

    def full_name
      if personal_detail.present?
        "#{personal_detail.first_name} #{personal_detail.last_name}"
      else
        "Employee ##{id}"
      end
    end

    private

    def generate_hamzis_id
      return if hamzis_id.present?
      return if hire_date.blank? # safety guard

      year = hire_date.year
      year_suffix = year.to_s[-2..] # e.g. "20" for 2020

      # Find the highest hamzis_id for this hire year
      last_id = Hr::Employee.where(
        hire_date: Date.new(year, 1, 1)..Date.new(year, 12, 31)
      ).maximum(:hamzis_id)

      if last_id.present? && last_id.end_with?(year_suffix)
        last_sequence = last_id[0..2].to_i
        sequence = (last_sequence + 1).to_s.rjust(3, "0")
      else
        sequence = "001"
      end

      self.hamzis_id = "#{sequence}#{year_suffix}" # e.g. "00120", "00221", "00322"
    end

    def user_role_and_email_valid
      staff_roles = %w[ceo cto qs site_manager engineer storekeeper hr accountant]
      unless user.role.in?(staff_roles)
        errors.add(:user, "must have a staff role")
      end

      unless user.email.ends_with?("@hamzis.com")
        errors.add(:user, "must have a Hamzis company email")
      end
    end
  end
end
