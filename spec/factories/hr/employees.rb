FactoryBot.define do
  factory :hr_employee, class: "Hr::Employee" do
    department        { "Engineering" }
    position_title    { "Civil Engineer" }
    hire_date         { Date.today }
    status            { :active }
    leave_balance     { 10 }
    performance_score { 4.5 }
    base_salary       { 250000.0 } # Added for payroll testing

    association :user, factory: [:user, :engineer]

    factory :hr_employee_with_detail do
      after(:create) do |employee|
        create(:personal_detail, employee: employee)
      end
    end

    trait :with_recurring_stats do
      after(:create) do |employee|
        create(:hr_recurring_adjustment, :allowance, employee: employee)
        create(:hr_recurring_adjustment, employee: employee)
      end
    end
  end

  factory :employee, parent: :hr_employee
end
