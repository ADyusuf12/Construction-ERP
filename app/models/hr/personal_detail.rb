module Hr
  class PersonalDetail < ApplicationRecord
    belongs_to :employee, class_name: "Hr::Employee", inverse_of: :personal_detail

    enum :gender, {
      male: 0,
      female: 1,
      other: 2
    }, prefix: true

    enum :means_of_identification, {
      nin: 0,
      passport: 1,
      drivers_license: 2,
      voters_card: 3,
      student_id: 4,
      nysc: 5
    }, prefix: true

    enum :marital_status, {
      single: 0,
      married: 1,
      divorced: 2,
      widowed: 3
    }, prefix: true

    validates :bank_name, :account_number, :account_name, presence: true
    validate :above_eighteen

    private

    def above_eighteen
      return if dob.blank?

      if dob > 18.years.ago.to_date
        errors.add(:dob, "Employee must be at least 18 years old.")
      end
    end
  end
end
