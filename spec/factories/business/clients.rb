FactoryBot.define do
  factory :business_client, class: "Business::Client" do
    sequence(:name) { |n| "Test Client #{n}" }
    sequence(:email) { |n| "client#{n}@hamzis.com" }

    association :user, factory: [ :user, :client ]

    trait :without_user do
      user { nil }
    end

    trait :with_projects do
      after(:create) do |client|
        create_list(:project, 2, client: client)
      end
    end
  end
end
