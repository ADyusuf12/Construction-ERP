FactoryBot.define do
  factory :accounting_deduction, class: "Accounting::Deduction" do
    association :salary, factory: :accounting_salary

    deduction_type { :tax }
    amount         { 100.0 }
    notes          { "Standard tax deduction" }

    trait :pension do
      deduction_type { :pension }
      amount         { 200.0 }
      notes          { "Pension contribution" }
    end

    trait :loan do
      deduction_type { :loan }
      amount         { 300.0 }
      notes          { "Loan repayment" }
    end

    trait :health_insurance do
      deduction_type { :health_insurance }
      amount         { 150.0 }
      notes          { "Health insurance premium" }
    end

    trait :other do
      deduction_type { :other }
      amount         { 50.0 }
      notes          { "Miscellaneous deduction" }
    end
  end
end
