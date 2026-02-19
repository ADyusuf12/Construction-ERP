FactoryBot.define do
  factory :accounting_deduction, class: "Accounting::Deduction" do
    association :salary, factory: :accounting_salary

    deduction_type { :tax }
    amount         { 1000.0 }
    notes          { "Standard tax deduction" }

    trait :pension do
      deduction_type { :pension }
      amount         { 2000.0 }
    end

    trait :loan do
      deduction_type { :loan }
      amount         { 5000.0 }
    end

    trait :recurring do
      deduction_type { :recurring }
    end
  end
end