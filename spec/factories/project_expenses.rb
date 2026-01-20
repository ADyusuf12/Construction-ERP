FactoryBot.define do
  factory :project_expense do
    association :project   # ensures a project is created alongside

    date        { Date.today }
    description { "Office supplies" }
    amount      { 500 }

    # Traits for variations
    trait :large do
      amount { 10_000 }
    end

    trait :recent do
      date { 2.days.ago }
    end

    trait :with_notes do
      notes { "Purchased from local vendor" }
    end
  end
end
