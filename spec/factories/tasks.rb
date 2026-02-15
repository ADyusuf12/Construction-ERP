FactoryBot.define do
  factory :task do
    association :project
    title   { "Test Task" }
    details { "Some details about the task" }
    status  { :pending }
    due_date { 1.week.from_now }
    weight  { 5 }

    # with assigned employees
    trait :with_employee do
      after(:create) do |task|
        employee = create(:hr_employee)
        create(:assignment, task: task, employee: employee)
      end
    end
  end
end
