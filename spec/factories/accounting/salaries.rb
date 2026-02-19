FactoryBot.define do
  factory :accounting_salary, class: "Accounting::Salary" do
    association :employee, factory: :hr_employee
    association :batch,    factory: :accounting_salary_batch

    base_pay   { 100000.0 }
    allowances { 10000.0 }
    status     { :pending }

    # net_pay is calculated by before_validation in the model

    trait :paid do
      status { :paid }
    end

    trait :failed do
      status { :failed }
    end

    trait :with_deductions do
      after(:create) do |salary|
        create(:accounting_deduction, salary: salary, amount: 5000)
        salary.save! # Triggers re-calculation of net_pay
      end
    end
  end
end