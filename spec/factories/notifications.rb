FactoryBot.define do
  factory :notification do
    association :recipient, factory: :user
    association :actor, factory: :user
    # For polymorphic, we need to provide an object.
    # We'll use a Task as a default notifiable.
    association :notifiable, factory: :task

    action { "system_update" }
    params { { message: "Test Notification Message" } }
    read_at { nil }

    trait :read do
      read_at { Time.current }
    end
  end
end
