class Assignment < ApplicationRecord
  belongs_to :task
  belongs_to :employee, class_name: "Hr::Employee", foreign_key: "employee_id"
end
