module Hr
  class AttendanceRecord < ApplicationRecord
    belongs_to :employee, class_name: "Hr::Employee"
    belongs_to :project

    enum :status, { present: 0, absent: 1, late: 2, on_leave: 3 }, prefix: true

    validates :date, presence: true
    validates :status, presence: true

    with_options if: -> { status_present? || status_late? } do
      validates :check_in_time, presence: true
      validates :check_out_time, presence: true
    end

    validate :check_out_after_check_in

    private

    def check_out_after_check_in
      return if check_in_time.blank? || check_out_time.blank?

      if check_out_time <= check_in_time
        errors.add(:check_out_time, "must be after check-in time")
      end
    end
  end
end
