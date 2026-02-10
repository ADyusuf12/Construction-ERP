module Hr
  class NextOfKin < ApplicationRecord
    belongs_to :employee, class_name: "Hr::Employee"

    validates :name, :relationship, :phone_number, presence: true
  end
end
