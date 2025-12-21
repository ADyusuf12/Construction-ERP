FactoryBot.define do
  factory :task do
    association :project
    title   { "Test Task" }
    details { "Some details about the task" }
    status  { :pending }
    due_date { 1.week.from_now }
    weight  { 5 }

    # with assigned users
    trait :with_user do
      after(:create) do |task|
        user = create(:user)
        create(:assignment, task: task, user: user)
      end
    end
  end
end
