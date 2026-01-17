FactoryBot.define do
  factory :project do
    association :user, factory: :user

    name        { "Test Project" }
    description { "A sample project for testing purposes" }
    status      { :ongoing }
    deadline    { 1.month.from_now }
    budget      { 50_000 }
    progress    { 0 } # starts at 0, recalculated by tasks

    # Traits for variations
    trait :completed do
      status   { :completed }
      progress { 100 }
    end

    trait :due_soon do
      deadline { 5.days.from_now }
    end

    trait :overdue do
      deadline { 2.days.ago }
      status   { :ongoing }
    end

    # With tasks
    trait :with_tasks do
      after(:create) do |project|
        create_list(:task, 3, project: project)
      end
    end
  end
end
