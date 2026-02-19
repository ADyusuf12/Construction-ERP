FactoryBot.define do
  factory :hr_recurring_adjustment, class: "Hr::RecurringAdjustment" do
    association :employee, factory: :hr_employee
    label           { "Health Insurance" }
    amount          { 5000.0 }
    adjustment_type { :deduction }
    active          { true }

    trait :allowance do
      label           { "Housing Allowance" }
      adjustment_type { :allowance }
      amount          { 15000.0 }
    end

    trait :inactive do
      active { false }
    end
  end
end
