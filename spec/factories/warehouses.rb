FactoryBot.define do
  factory :warehouse do
    sequence(:name) { |n| "Warehouse #{n}" }
    sequence(:code) { |n| "WH#{n.to_s.rjust(3, '0')}" }
    address { "123 Main St" }
  end
end
