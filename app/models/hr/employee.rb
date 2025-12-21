module Hr
  class Employee < ApplicationRecord
    belongs_to :user, optional: true

    # Employment status with prefix to avoid method collisions
    enum :status, { active: 0, on_leave: 1, terminated: 2 }, prefix: true

    validates :hamzis_id, presence: true, uniqueness: true
    validates :department, presence: true
    validates :position_title, presence: true

    # Generate hamzis_id before validation so presence check passes
    before_validation :generate_hamzis_id, on: :create

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
  end
end
