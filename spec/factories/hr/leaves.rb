FactoryBot.define do
  factory :hr_leave, class: "Hr::Leave" do
    association :employee, factory: :hr_employee
    association :manager,  factory: :hr_employee

    start_date { Date.today }
    end_date   { Date.today + 5.days }
    reason     { "Annual Leave" }
    status     { :pending }

    trait :approved do
      status { :approved }
    end

    trait :rejected do
      status { :rejected }
    end

    trait :cancelled do
      status { :cancelled }
    end
  end
end
