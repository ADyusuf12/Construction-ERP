FactoryBot.define do
  factory :hr_employee, class: "Hr::Employee" do
    department        { "Engineering" }
    position_title    { "Civil Engineer" }
    hire_date         { Date.today }
    status            { :active }
    leave_balance     { 10 }
    performance_score { 4.5 }

    # Ensure hamzis_id is generated
    before(:create) do |employee|
      employee.hire_date ||= Date.today
    end

    association :user, factory: [ :user, :engineer ]

    factory :hr_employee_with_detail do
      after(:create) do |employee|
        create(:personal_detail, employee: employee)
      end
    end
  end

  # alias so tests can call `create(:employee)`
  factory :employee, parent: :hr_employee
end
