FactoryBot.define do
  factory :project do
    association :user, factory: :user
    association :client, factory: :business_client

    name        { "Test Project" }
    description { "A sample project for testing purposes" }
    status      { :ongoing }
    deadline    { 1.month.from_now }
    budget      { 50_000 }
    location    { "Abuja" }
    address     { "Jabi, Abuja" }

    # Traits for variations
    trait :completed do
      status { :completed }
      after(:create) do |project|
        create_list(:task, 3, project: project, status: :done, weight: 10)
      end
    end

    trait :due_soon do
      deadline { 5.days.from_now }
    end

    trait :overdue do
      deadline { 2.days.ago }
      status   { :ongoing }
    end

    trait :with_tasks do
      after(:create) do |project|
        create_list(:task, 3, project: project)
      end
    end
  end
end
