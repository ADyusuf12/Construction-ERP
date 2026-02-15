FactoryBot.define do
  factory :assignment do
    association :task
    association :employee, factory: :hr_employee
  end
end
