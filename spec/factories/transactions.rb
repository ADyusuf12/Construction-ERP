FactoryBot.define do
  factory :transaction do
    association :project
    date        { Date.today }
    description { "Test transaction" }
    amount      { 1000 }
    transaction_type { :invoice }
    status      { :unpaid }

    trait :receipt do
      transaction_type { :receipt }
    end

    trait :paid do
      status { :paid }
    end
  end
end
