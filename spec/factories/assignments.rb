FactoryBot.define do
  factory :assignment do
    association :task
    association :user
  end
end
