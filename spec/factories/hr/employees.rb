FactoryBot.define do
  factory :hr_employee, class: "Hr::Employee" do
    department        { "Engineering" }
    position_title    { "Civil Engineer" }
    hire_date         { Date.today }
    status            { :active }
    leave_balance     { 10 }
    performance_score { 4.5 }

    association :user, factory: :user

    # Nested factory to automatically attach a personal detail
    factory :hr_employee_with_detail do
      after(:create) do |employee|
        create(:personal_detail, employee: employee)
      end
    end
  end
end
